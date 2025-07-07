defmodule SlidegenWeb.SessionLiveTest do
  use SlidegenWeb.ConnCase

  import Phoenix.LiveViewTest
  import Slidegen.ContentFixtures

  @create_attrs %{topic: "some topic"}
  @update_attrs %{topic: "some updated topic"}
  @invalid_attrs %{topic: nil}
  defp create_session(_) do
    session = session_fixture()

    %{session: session}
  end

  describe "Index" do
    setup [:create_session]

    test "lists all sessions", %{conn: conn, session: session} do
      {:ok, _index_live, html} = live(conn, ~p"/sessions")

      assert html =~ "Listing Sessions"
      assert html =~ session.topic
    end

    test "saves new session", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sessions")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Session")
               |> render_click()
               |> follow_redirect(conn, ~p"/sessions/new")

      assert render(form_live) =~ "New Session"

      assert form_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#session-form", session: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sessions")

      html = render(index_live)
      assert html =~ "Session created successfully"
      assert html =~ "some topic"
    end

    test "updates session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, ~p"/sessions")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#sessions-#{session.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/sessions/#{session.slug}/edit")

      assert render(form_live) =~ "Edit Session"

      assert form_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#session-form", session: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sessions")

      html = render(index_live)
      assert html =~ "Session updated successfully"
      assert html =~ "some updated topic"
    end

    test "deletes session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, ~p"/sessions")

      assert index_live |> element("#sessions-#{session.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sessions-#{session.id}")
    end
  end

  describe "Show" do
    setup [:create_session]

    test "displays session", %{conn: conn, session: session} do
      {:ok, _show_live, html} = live(conn, ~p"/sessions/#{session.slug}")

      assert html =~ "Show Session"
      assert html =~ session.topic
    end

    test "updates session and returns to show", %{conn: conn, session: session} do
      {:ok, show_live, _html} = live(conn, ~p"/sessions/#{session.slug}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/sessions/#{session.slug}/edit?return_to=show")

      assert render(form_live) =~ "Edit Session"

      assert form_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#session-form", session: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sessions/#{session.slug}")

      html = render(show_live)
      assert html =~ "Session updated successfully"
      assert html =~ "some updated topic"
    end
  end

  describe "Slug generation" do
    test "slug is generated and is human-readable" do
      session = session_fixture(%{title: "Elixir for Beginners"})
      assert session.slug =~ "elixir-for-beginners"
      assert String.length(session.slug) >= String.length("elixir-for-beginners")
    end

    test "slug is unique for sessions with same title" do
      session1 = session_fixture(%{title: "Phoenix LiveView"})
      session2 = session_fixture(%{title: "Phoenix LiveView"})
      assert session1.slug != session2.slug
      assert String.starts_with?(session1.slug, "phoenix-liveview")
      assert String.starts_with?(session2.slug, "phoenix-liveview")
    end
  end
end
