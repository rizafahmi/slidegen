defmodule SlidegenWeb.SessionLive.Show do
  use SlidegenWeb, :live_view

  alias Slidegen.Content

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Session {@session.id}
        <:subtitle>This is a session record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/sessions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/sessions/#{@session.slug}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit session
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Topic">{@session.topic}</:item>
        <:item title="Title">{@session.title}</:item>
        <:item title="Slug">{@session.slug}</:item>
        <:item title="Description">{@session.description}</:item>
        <:item title="Taget audience">{@session.taget_audience}</:item>
        <:item title="Language">{@session.language}</:item>
        <:item title="Content">{@session.content}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Session")
     |> assign(:session, Content.get_session_by_slug!(slug))}
  end
end
