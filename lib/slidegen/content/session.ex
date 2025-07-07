defmodule Slidegen.Content.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sessions" do
    field :topic, :string
    field :title, :string
    field :description, :string
    field :taget_audience, :string
    field :language, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:topic, :title, :description, :taget_audience, :language, :content])
    |> validate_required([:topic])
    |> validate_length(:topic, min: 3, max: 255)
  end
end
