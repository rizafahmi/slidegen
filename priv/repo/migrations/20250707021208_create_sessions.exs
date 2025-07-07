defmodule Slidegen.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :topic, :string
      add :title, :string
      add :description, :text
      add :taget_audience, :text
      add :language, :string
      add :content, :text

      timestamps(type: :utc_datetime)
    end
  end
end
