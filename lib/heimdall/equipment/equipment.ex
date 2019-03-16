defmodule Heimdall.Equipment do
  @moduledoc """
  The Equipment context.
  """

  import Ecto.Query, warn: false
  alias Heimdall.Repo

  alias Heimdall.Equipment.Door
  alias Heimdall.Account.User

  @doc """
  Returns the list of doors.

  ## Examples

      iex> list_doors()
      [%Door{}, ...]

  """
  def list_doors(), do: Repo.all(Door)

  def get_doors(%User{doors: doors}) when is_list(doors), do: doors
  def get_doors(%User{id: _id} = user), do: user |> Repo.preload([:doors]) |> get_doors()

  @doc """
  Gets a single door.

  Raises `Ecto.NoResultsError` if the Door does not exist.

  ## Examples

      iex> get_door!(123)
      %Door{}

      iex> get_door!(456)
      ** (Ecto.NoResultsError)

  """
  def get_door!(id), do: Repo.get!(Door, id)

  @doc """
  Creates a door.

  ## Examples

      iex> create_door(%{field: value})
      {:ok, %Door{}}

      iex> create_door(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_door(attrs \\ %{}) do
    %Door{}
    |> Door.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a door.

  ## Examples

      iex> update_door(door, %{field: new_value})
      {:ok, %Door{}}

      iex> update_door(door, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_door(%Door{} = door, attrs) do
    door
    |> Door.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Door.

  ## Examples

      iex> delete_door(door)
      {:ok, %Door{}}

      iex> delete_door(door)
      {:error, %Ecto.Changeset{}}

  """
  def delete_door(%Door{} = door), do: Repo.delete(door)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking door changes.

  ## Examples

      iex> change_door(door)
      %Ecto.Changeset{source: %Door{}}

  """
  def change_door(%Door{} = door), do: Door.changeset(door, %{})
end
