defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Comedy Drama Action) do
        Multimedia.create_category!(name)
      end

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
          name
        end

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  @valid_attrs %{description: "some description", title: "some title", url: "some url"}
  @invalid_attrs %{description: nil, title: nil, url: nil}

  describe "videos" do
    alias Rumbl.Multimedia.Video

    test "list_videos/0 returns all videos" do
      user = user_fixture()
      %Video{id: id1} = video_fixture(user)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(user)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id" do
      user = user_fixture()
      %Video{id: id} = video_fixture(user)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/1 with valid data creates a video" do
      user = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(user, @valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(user, @invalid_attrs)
    end

    test "update_video/2 with valid data returns Ecto.Changeset" do
      user = user_fixture
      video = video_fixture(user)
      assert {:ok, %Video{} = video} = Multimedia.update_video(video, %{title: "new title"})
      assert video.title == "new title"
    end

    test "update_video/2 with invalid data returns error changeset" do
      user = user_fixture()
      video = video_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
    end

    test "delete_video/1 deletes the video" do
      user = user_fixture()
      video = video_fixture(user)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert [] = Multimedia.list_videos()
    end

    test "change_video/1 returns a video changeset" do
      user = user_fixture()
      video = video_fixture(user)
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end
