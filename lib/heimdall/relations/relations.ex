defmodule Heimdall.Relations do
  @moduledoc """
  The Relations context.
  """

  import Ecto.Query, warn: false
  alias Heimdall.Repo

  alias Heimdall.Relations.DoorUser

  @spec can_user_access_door(nil | DoorUser.t()) :: boolean()
  def can_user_access_door(%DoorUser{opens_remaining: opens_remaining, date_expires: date_expires}) do
    opens_valid = opens_remaining > 0

    date_valid =
      date_expires
      |> case do
        nil ->
          true

        date ->
          DateTime.compare(date, DateTime.utc_now()) != :lt
      end

    date_valid && opens_valid
  end

  def can_user_access_door(_), do: false

  @spec process_user_door_access(integer(), integer()) :: boolean()
  def process_user_door_access(user_id, door_id) do
    from(
      du in DoorUser,
      where: du.door_id == ^door_id and du.user_id == ^user_id,
      limit: 1
    )
    |> Repo.one()
    |> process_user_door_access()
  end

  @spec process_user_door_access(DoorUser.t() | any()) :: boolean()
  def process_user_door_access(%DoorUser{} = door_user) do
    if door_user.opens_remaining != nil do
      update_data = %{
        opens_remaining: door_user.opens_remaining - 1
      }

      door_user
      |> update_door_user(update_data)
    end

    can_user_access_door(door_user)
  end

  def process_user_door_access(_params), do: false

  @doc """
  Returns the list of door_users.

  ## Examples

      iex> list_door_users()
      [%DoorUser{}, ...]

  """
  def list_door_users, do: Repo.all(DoorUser)

  @doc """
  Gets a single door_user.

  Raises if the Door user does not exist.

  ## Examples

      iex> get_door_user!(123)
      %DoorUser{}

  """
  def get_door_user!(id), do: Repo.get(DoorUser, id)

  @doc """
  Creates a door_user.

  ## Examples

      iex> create_door_user(%{field: value})
      {:ok, %DoorUser{}}

      iex> create_door_user(%{field: bad_value})
      {:error, ...}

  """
  def create_door_user(attrs \\ %{}) do
    %DoorUser{}
    |> DoorUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a door_user.

  ## Examples

      iex> update_door_user(door_user, %{field: new_value})
      {:ok, %DoorUser{}}

      iex> update_door_user(door_user, %{field: bad_value})
      {:error, ...}

  """
  def update_door_user(%DoorUser{} = door_user, attrs) do
    door_user
    |> DoorUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a DoorUser.

  ## Examples

      iex> delete_door_user(door_user)
      {:ok, %DoorUser{}}

      iex> delete_door_user(door_user)
      {:error, ...}

  """
  def delete_door_user(%DoorUser{} = door_user), do: Repo.delete(door_user)

  @doc """
  Returns a datastructure for tracking door_user changes.

  ## Examples

      iex> change_door_user(door_user)
      %Todo{...}

  """
  def change_door_user(%DoorUser{} = door_user), do: DoorUser.changeset(door_user, %{})
end
