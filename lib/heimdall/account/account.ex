defmodule Heimdall.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Heimdall.Repo

  alias Heimdall.Account.User
  alias Heimdall.{Permission, Role}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users() do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @spec has_permission(User.t(), Permission.t()) :: any()
  def has_permission(%User{id: user_id}, %Permission{id: p_id, name: p_name}) do
    from(
      [p, _r, u] in get_permissions_base(true),
      where:
        u.id == ^user_id and
          (p.name == ^(p_name || "") or
             p.id == ^(p_id || 0)),
      select: p.id,
      limit: 1
    )
    |> Repo.one() != nil
  end

  @spec get_permissions_of(User.t() | Role.t()) :: [Permission.t()]
  def get_permissions_of(%Role{id: id}), do: get_permissions_from_role(id)
  def get_permissions_of(%User{role: %Role{} = role}), do: get_permissions_of(role)
  def get_permissions_of(%User{id: id}), do: get_permissions_from_user(id)
  def get_permissions_of(%User{role_id: id}), do: get_permissions_from_role(id)

  defp get_permissions_from_role(id) when is_integer(id) do
    from(
      [_p, r] in get_permissions_base(),
      where: r.id == ^id
    )
    |> Repo.all()
  end

  defp get_permissions_from_user(id) when is_integer(id) do
    from(
      [_p, _r, u] in get_permissions_base(true),
      where: u.id == ^id
    )
    |> Repo.all()
  end

  defp get_permissions_base() do
    from(
      p in Permission,
      inner_join: r in Role,
      on: fragment("? & ? <> 0", p.bit, r.permissions)
    )
  end

  defp get_permissions_base(true) do
    from(
      [_p, r] in get_permissions_base(),
      left_join: u in User,
      on: r.id == u.role_id
    )
  end
end
