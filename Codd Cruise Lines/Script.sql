PROMPT Welcome to our script.  This report will look up data
PROMPT using the room number you provide.
PROMPT
ACCEPT 	vRoomNumber PROMPT "Enter a room number: "
SELECT 	ROOM_NUMBER, STYLE, WINDOW
FROM 	SHIP_CABINS
WHERE	ROOM_NUMBER = &vRoomNumber;
PROMPT	Remember, you asked for the room number &vRoomNumber.