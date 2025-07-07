defmodule Slidegen.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Slidegen.Content` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        content: "some content",
        description: "some description",
        language: "some language",
        taget_audience: "some taget_audience",
        title: "some title",
        topic: "some topic"
      })
      |> Slidegen.Content.create_session()

    session
  end
end
