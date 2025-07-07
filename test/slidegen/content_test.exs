defmodule Slidegen.ContentTest do
  use Slidegen.DataCase

  alias Slidegen.Content

  describe "sessions" do
    alias Slidegen.Content.Session

    import Slidegen.ContentFixtures

    @invalid_attrs %{description: nil, title: nil, language: nil, topic: nil, taget_audience: nil, content: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Content.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Content.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{description: "some description", title: "some title", language: "some language", topic: "some topic", taget_audience: "some taget_audience", content: "some content"}

      assert {:ok, %Session{} = session} = Content.create_session(valid_attrs)
      assert session.description == "some description"
      assert session.title == "some title"
      assert session.language == "some language"
      assert session.topic == "some topic"
      assert session.taget_audience == "some taget_audience"
      assert session.content == "some content"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", language: "some updated language", topic: "some updated topic", taget_audience: "some updated taget_audience", content: "some updated content"}

      assert {:ok, %Session{} = session} = Content.update_session(session, update_attrs)
      assert session.description == "some updated description"
      assert session.title == "some updated title"
      assert session.language == "some updated language"
      assert session.topic == "some updated topic"
      assert session.taget_audience == "some updated taget_audience"
      assert session.content == "some updated content"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_session(session, @invalid_attrs)
      assert session == Content.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Content.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Content.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Content.change_session(session)
    end
  end
end
