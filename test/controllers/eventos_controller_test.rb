require "test_helper"

class EventosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evento = eventos(:one)
  end

  test "should get index" do
    get eventos_url, as: :json
    assert_response :success
  end

  test "should create evento" do
    assert_difference("Evento.count") do
      post eventos_url, params: { evento: { autor_id: @evento.autor_id, conteudo: @evento.conteudo, data: @evento.data, local: @evento.local, tags: @evento.tags, titulo: @evento.titulo, url_imagem: @evento.url_imagem, status: @evento.status } }, as: :json
    end

    assert_response :created
  end

  test "should show evento" do
    get evento_url(@evento), as: :json
    assert_response :success
  end

  test "should update evento" do
    patch evento_url(@evento), params: { evento: { autor_id: @evento.autor_id, conteudo: @evento.conteudo, data: @evento.data, local: @evento.local, tags: @evento.tags, titulo: @evento.titulo, url_imagem: @evento.url_imagem, status:"publicado" } }, as: :json
    assert_response :success
  end

  test "should destroy evento" do
    assert_difference("Evento.count", -1) do
      delete evento_url(@evento), as: :json
    end

    assert_response :no_content
  end
end
