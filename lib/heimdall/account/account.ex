defmodule Heimdall.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Heimdall.Repo

  alias Heimdall.Account.{User, Role, Permission}
  alias Heimdall.Equipment.Door
  alias Heimdall.Relations.DoorUser

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

  @spec get_owned_doors(User.t()) :: list()
  def get_owned_doors(%User{} = user) do
    user
    |> owned_doors_query()
    |> Repo.all()
  end

  @spec owned_doors_query(User.t()) :: Ecto.Query.t()
  def owned_doors_query(%User{id: id}) do
    from(
      du in DoorUser,
      left_join: d in Door,
      on: d.id == du.door_id,
      left_join: u in User,
      on: u.id == du.user_id,
      select: d,
      where: u.id == ^id and du.owner == true
    )
  end

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles() do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  @doc """
  Returns the list of permissions.

  ## Examples

      iex> list_permissions()
      [%Permission{}, ...]

  """
  def list_permissions() do
    Repo.all(Permission)
  end

  @doc """
  Gets a single permission.

  Raises `Ecto.NoResultsError` if the Permission does not exist.

  ## Examples

      iex> get_permission!(123)
      %Permission{}

      iex> get_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Creates a permission.

  ## Examples

      iex> create_permission(%{field: value})
      {:ok, %Permission{}}

      iex> create_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a permission.

  ## Examples

      iex> update_permission(permission, %{field: new_value})
      {:ok, %Permission{}}

      iex> update_permission(permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Permission.

  ## Examples

      iex> delete_permission(permission)
      {:ok, %Permission{}}

      iex> delete_permission(permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permission changes.

  ## Examples

      iex> change_permission(permission)
      %Ecto.Changeset{source: %Permission{}}

  """
  def change_permission(%Permission{} = permission) do
    Permission.changeset(permission, %{})
  end

  @spec has_permission(User.t(), Permission.t() | list()) :: any()
  def has_permission(%User{id: user_id}, permissions) when is_list(permissions) do
    permission_names =
      permissions
      |> Enum.map(fn permission ->
        permission
        |> case do
          %Permission{name: name} ->
            name

          name when is_binary(name) ->
            name

          _ ->
            nil
        end
      end)
      |> Enum.filter(& &1)

    permission_ids =
      permissions
      |> Enum.map(fn permission ->
        permission
        |> case do
          %Permission{id: id} ->
            id

          id when is_integer(id) ->
            id

          _ ->
            nil
        end
      end)
      |> Enum.filter(& &1)

    from(
      [p, _r, u] in get_permissions_base(true),
      where:
        u.id == ^user_id and
          (fragment("(? = ANY(?))", p.id, ^permission_ids) or
             fragment("(? = ANY(?))", p.name, ^permission_names)),
      select: p.id,
      limit: 1
    )
    |> Repo.one() != nil
  end

  def has_permission(%User{} = user, permission) do
    has_permission(user, [permission])
  end

  def has_permission(user_id, permission) when is_integer(user_id) do
    %User{id: user_id}
    |> has_permission(permission)
  end

  @spec has_permissions(User.t() | integer(), list(String.t())) :: boolean()
  def has_permissions(user_id, permission_names) when is_integer(user_id) do
    %User{id: user_id}
    |> has_permissions(permission_names)
  end

  def has_permissions(%User{id: user_id}, permission_names) when is_list(permission_names) do
    from(
      [p, _r, u] in get_permissions_base(true),
      where: u.id == ^user_id and fragment("? = ALL(?)", p.name, ^permission_names),
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
  def get_permissions_of(_), do: []

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
