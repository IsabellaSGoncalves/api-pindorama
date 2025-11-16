unless Rails.env.test?
  require "espeak"
  include ESpeak
end

require "open3" 

module Conf
  module Api
    module Tts
      class TtsController < ApplicationController
        def create
          text = params[:text].to_s.strip

          if text.blank?
            return render json: { error: "texto é obrigatório" }, status: :unprocessable_entity
          end

          filename_wav = "speech-#{SecureRandom.hex(10)}.wav"
          path_wav = Rails.root.join("tmp", filename_wav)
          filename_mp3 = "speech-#{SecureRandom.hex(10)}.mp3"
          path_mp3 = Rails.root.join("tmp", filename_mp3)

          if Rails.env.test?
            File.write(path_mp3, "")
          else
            speech = ESpeak::Speech.new(text, voice: "brazil-mbrola-4", speed: 140)
            speech.save(path_wav.to_s)


            ffmpeg_cmd = "ffmpeg -y -i #{Shellwords.escape(path_wav.to_s)} -codec:a libmp3lame -qscale:a 2 #{Shellwords.escape(path_mp3.to_s)}"
            stdout_str, stderr_str, status = Open3.capture3(ffmpeg_cmd)
            unless status.success?
              Rails.logger.error("Erro ao converter WAV para MP3: #{stderr_str}")
              return render json: { error: "Falha ao gerar MP3" }, status: :internal_server_error
            end

            File.delete(path_wav) if File.exist?(path_wav)
          end

          unless File.exist?(path_mp3)
            Rails.logger.error("Arquivo MP3 não foi gerado: #{path_mp3}")
            return render json: { error: "Falha ao gerar o áudio" }, status: :internal_server_error
          end

          send_file path_mp3.to_s,
                    type: "audio/mpeg",
                    disposition: "inline",
                    filename: filename_mp3

          Thread.new do
            sleep 30
            begin
              File.delete(path_mp3) if File.exist?(path_mp3)
            rescue => e
              Rails.logger.warn("Falha ao apagar arquivo temporário: #{e.message}")
            end
          end
        rescue => e
          Rails.logger.error("Erro ao gerar áudio: #{e.message}")
          render json: { error: "Erro ao gerar áudio: #{e.message}" }, status: :internal_server_error
        end
      end
    end
  end
end
