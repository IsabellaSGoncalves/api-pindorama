# api_pindorama/services/coordenada_service.rb

require 'faraday'
require 'json'

class CoordenadaService
  API_MAPA_URL = ENV.fetch("API_MAPA_URL", "http://api-mapa:5000/coordenadas/gerar")

  def self.gerar(artigo_id)
    # ⚠️ Use Faraday com um timeout de leitura explícito
    connection = Faraday.new(url: API_MAPA_URL) do |faraday|
      faraday.options.timeout = 5 # Timeout de 5 segundos
      faraday.adapter Faraday.default_adapter 
    end

    response = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { id: artigo_id }.to_json
    end

    return nil unless response.status == 200
    
    data = JSON.parse(response.body)

    # A API retorna
    { lat: data["coordenada"]["lat"].to_f, lon: data["coordenada"]["lon"].to_f }
    
  rescue Faraday::Error => e
    # Captura erros de Faraday (timeout, falha de conexão)
    puts "ERRO ao chamar API de coordenadas: #{e}"
    nil
  rescue => e
    puts "ERRO desconhecido no CoordenadaService: #{e}"
    nil
  end
end