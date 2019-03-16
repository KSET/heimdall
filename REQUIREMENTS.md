# REQUIREMENTS
Users go up to doors and it either beeps at them angrily or opens with a poof of magic.

Admins add users, doors, and permissions. They can roam freely.

Bosses manage access to doors.

## Roles (basic)
Admins:
  * Basically manages everything and everyone
  * Add/manage doors, users, and roles
  * Can enter anywhere

Boss:
  * Controlls access to owned doors
  * Add users to doors
    * Permanent (can enter freely)
    * Temporary (limited time)
    * One-time (limited number of uses/entries)
  * View door logs

Users:
  * Plebs
  * Can view which doors they have access to (and with which restrictions)

## Usage
DOOR:
  * Door sends a request to the server with the card ID and door ID
  * Server should log the request (door, user, time, success) and respond with whether the user has permission to enter

WEB:
  * Admins
    * Can add/modify/delete all users and assign roles
    * Can add doors to bosses
    * Can add or modify permissions
  * Boss
    * Can add users to doors
  * Users
    * Can view which doors they have access to

## Database layout
Options in [square brackets] are optional.

Comments are in (round brackets) next to column names.

Arrows represent a relationship from a column -> to a table

Users:
  * user_id
  * first_name
  * last_name
  * password
  * code                (The user's RFID code)
  * role_id             -> Roles.id
  * created_by_id       -> Users.id

Roles:
  * role_id
  * name                (eg. admin, user, boss)
  * permissions         (unix-like bits to represent which permissions the role has eg. 0b0101 means the user has permissions with bit 0 and 4)

Permissions: (A way to name permissions eg. add-door, add-user, etc.)
  * permission_id
  * bit                 (In which bit to store the information eg. 0 to store it in the first (rightmost) bit and 8 to store it in the third bit)
  * name                (Name for the permission)

Doors:
  * door_id
  * code                (Door/reader code)
  * name                (Friendly door name eg. Comp door)

DoorUsers:
  * door_id             -> Doors.id
  * user_id             -> Users.id
  * owner               (Whether the user is the (one of the) owner(s) of the door)
  * [opens_remaining]   (Number of times the user can open the door at this point)
  * [date_expires]      (Date when the access expires)
  * date_assigned

Log: (read only)
  * door_id             -> Doors.id
  * user_id             -> Users.id
  * access_granted      (Whether the user was granted access on the request)
  * date_logged
