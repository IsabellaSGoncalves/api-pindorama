require "test_helper"

class ArtigosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artigo = artigos(:one)
  end

  test "should get index" do
    get artigos_url, as: :json
    assert_response :success
  end

  test "should create artigo" do
    assert_difference("Artigo.count") do
      post artigos_url, params: { artigo: { autor_id: @artigo.autor_id, conteudo: @artigo.conteudo, data: @artigo.data, local: @artigo.local, tags: @artigo.tags, titulo: @artigo.titulo, url_imagem: @artigo.url_imagem, status: @artigo.status } }, as: :json
    end

    assert_response :created
  end

  test "should show artigo" do
    get artigo_url(@artigo), as: :json
    assert_response :success
  end

  test "should update artigo" do
    patch artigo_url(@artigo), params: { artigo: { autor_id: @artigo.autor_id, conteudo: @artigo.conteudo, data: @artigo.data, local: @artigo.local, tags: @artigo.tags, titulo: @artigo.titulo, url_imagem: @artigo.url_imagem, status: "publicado" } }, as: :json
    assert_response :success
  end

  test "should destroy artigo" do
    assert_difference("Artigo.count", -1) do
      delete artigo_url(@artigo), as: :json
    end

    assert_response :no_content
  end
end
