defmodule SlidegenWeb.SessionLive.Index do
  use SlidegenWeb, :live_view

  alias Slidegen.Content

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Sessions
        <:actions>
          <.button variant="primary" navigate={~p"/sessions/new"}>
            <.icon name="hero-plus" /> New Session
          </.button>
        </:actions>
      </.header>

      <.table
        id="sessions"
        rows={@streams.sessions}
        row_click={fn {_id, session} -> JS.navigate(~p"/sessions/#{session}") end}
      >
        <:col :let={{_id, session}} label="Topic">{session.topic}</:col>
        <:col :let={{_id, session}} label="Title">{session.title}</:col>
        <:col :let={{_id, session}} label="Description">{session.description}</:col>
        <:col :let={{_id, session}} label="Taget audience">{session.taget_audience}</:col>
        <:col :let={{_id, session}} label="Language">{session.language}</:col>
        <:col :let={{_id, session}} label="Content">{session.content}</:col>
        <:action :let={{_id, session}}>
          <div class="sr-only">
            <.link navigate={~p"/sessions/#{session}"}>Show</.link>
          </div>
          <.link navigate={~p"/sessions/#{session}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, session}}>
          <.link
            phx-click={JS.push("delete", value: %{id: session.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Sessions")
     |> stream(:sessions, Content.list_sessions())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Content.get_session!(id)
    {:ok, _} = Content.delete_session(session)

    {:noreply, stream_delete(socket, :sessions, session)}
  end
end
