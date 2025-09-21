# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_20_212702) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "artigos", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "conteudo", null: false
    t.text "tags", default: [], array: true
    t.string "url_imagem"
    t.string "local", null: false
    t.timestamptz "data", default: -> { "timezone('America/Sao_Paulo'::text, now())" }
    t.bigint "autor_id"
    t.string "status", default: "rascunho", null: false
    t.index ["autor_id"], name: "index_artigos_on_autor_id"
  end

  create_table "autors", force: :cascade do |t|
    t.string "nome", null: false
    t.string "foto"
    t.string "email", null: false
    t.string "senha", null: false
    t.index ["email"], name: "index_autors_on_email", unique: true
  end

  create_table "eventos", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "conteudo", null: false
    t.text "tags", default: [], array: true
    t.string "url_imagem"
    t.string "local", null: false
    t.timestamptz "data", null: false
    t.bigint "autor_id"
    t.string "status", default: "rascunho", null: false
    t.index ["autor_id"], name: "index_eventos_on_autor_id"
  end

  add_foreign_key "artigos", "autors", on_delete: :nullify
  add_foreign_key "eventos", "autors", on_delete: :nullify
end
