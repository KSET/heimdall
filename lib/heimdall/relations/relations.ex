defmodule Heimdall.Relations do
  @moduledoc """
  The Relations context.
  """

  import Ecto.Query, warn: false
  alias Heimdall.Repo

  alias Heimdall.Relations.DoorUser
  alias Heimdall.Account
  alias Heimdall.Account.User
  alias Heimdall.Equipment.Door

  def process_user_door_access(user_code, door_code) when is_binary(user_code) and is_binary(door_code) do
    from(
      du in DoorUser,
      left_join: u in User,
      on: u.id == du.user_id,
      left_join: d in Door,
      on: d.id == du.door_id,
      where: d.code == ^door_code and u.code == ^user_code,
      limit: 1
    )
    |> Repo.one()
    |> case do
      %DoorUser{} = door_user ->
        update_door_user_on_access(door_user)
        can_user_access_door(door_user.user_id, door_user)

      _ ->
        Account.has_permission(user_code, "door:bypass")
    end
  end

  defp update_door_user_on_access(%DoorUser{} = door_user) do
    if door_user.opens_remaining != nil do
      update_data = %{
        opens_remaining: door_user.opens_remaining - 1
      }

      door_user
      |> update_door_user(update_data)
    end
  end

  defp can_user_access_door(user_id, %DoorUser{} = door_user) do
    opens_valid = door_user.opens_remaining > 0

    date_valid =
      door_user.date_expires
      |> case do
        nil ->
          true

        date ->
          DateTime.compare(date, DateTime.utc_now()) != :lt
      end

    (date_valid && opens_valid) || can_user_access_door(user_id)
  end

  defp can_user_access_door(user_id, _), do: can_user_access_door(user_id)

  defp can_user_access_door(user_id), do: Account.has_permission(user_id, "door:bypass")

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
