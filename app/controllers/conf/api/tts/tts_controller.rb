require "espeak"
include ESpeak

module Conf
  module Api
    module Tts
      class TtsController < ApplicationController
        def create
          text = params[:text].to_s.strip

          if text.blank?
            return render json: { error: "texto é obrigatório" }, status: :unprocessable_entity
          end

          filename = "speech-#{SecureRandom.hex(10)}.mp3"
          path = Rails.root.join("tmp", filename)

          speech = ESpeak::Speech.new(text, voice: "brazil-mbrola-4", speed: 140)
          speech.save(path.to_s)

          unless File.exist?(path)
            Rails.logger.error("Arquivo MP3 não foi gerado: #{path}")
            return render json: { error: "Falha ao gerar o áudio" }, status: :internal_server_error
          end

          send_file path.to_s,
                    type: "audio/mpeg",
                    disposition: "inline",
                    filename: filename

          Thread.new do
            sleep 30
            begin
              File.delete(path) if File.exist?(path)
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
