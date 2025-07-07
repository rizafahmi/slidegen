defmodule Slidegen.Content.Session do
  @moduledoc """
  Ecto schema and changeset logic for sessions, including automatic slug generation.
  """
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
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  defp slugify(nil), do: nil

  defp slugify("") do
    nil
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/u, "")
    |> String.replace(~r/[\s-]+/u, "-")
    |> String.trim("-")
  end

  defp put_slug(changeset) do
    if get_field(changeset, :slug) do
      changeset
    else
      base = get_field(changeset, :title) || get_field(changeset, :topic) || "session"
      slug = slugify(base)

      slug =
        if slug && slug != "" do
          slug
        else
          "session"
        end

      final_slug =
        case Slidegen.Repo.get_by(__MODULE__, slug: slug) do
          nil ->
            slug

          _ ->
            slug <>
              "-" <>
              (Base.url_encode64(:crypto.strong_rand_bytes(3), padding: false)
               |> String.replace("_", "")
               |> String.replace("-", ""))
        end

      put_change(changeset, :slug, final_slug)
    end
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:topic, :title, :description, :taget_audience, :language, :content, :slug])
    |> validate_required([:topic])
    |> validate_length(:topic, min: 3, max: 255)
    |> unique_constraint(:slug)
    |> put_slug()
  end
end
