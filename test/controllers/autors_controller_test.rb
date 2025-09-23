require "test_helper"

class AutorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @autor = autors(:one)
  end

  test "should get index" do
    get autors_url, as: :json
    assert_response :success
  end

  test "should create autor" do
    assert_difference("Autor.count") do
      post autors_url, params: { autor: { 
        email: "novo_email_#{SecureRandom.hex(4)}@exemplo.com", 
        foto: @autor.foto, 
        nome: @autor.nome, 
        senha: @autor.senha 
      } }, as: :json
    end

    assert_response :created
  end


  test "should show autor" do
    get autor_url(@autor), as: :json
    assert_response :success
  end

  test "should update autor" do
    patch autor_url(@autor), params: { autor: { email: @autor.email, foto: @autor.foto, nome: @autor.nome, senha: @autor.senha } }, as: :json
    assert_response :success
  end

  test "should destroy autor" do
    assert_difference("Autor.count", -1) do
      delete autor_url(@autor), as: :json
    end

    assert_response :no_content
  end
end
