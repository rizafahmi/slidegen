defmodule Slidegen.Repo.Migrations.AddSlugToSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :slug, :string
    end

    create unique_index(:sessions, [:slug])
  end
end
