So first I learned how to find a bot token and then also the ID of an open
chat with a user.

Next I learned that `/var/log/` is the directory where all system logs are
stored. Logs should be kept in the standard location, that’s more correct.
But since I’m doing everything for my own PC, it’s better to create a
separate directory in my home folder and save logs there, because I don’t
have permission to access `/var/log`.

Something new: `local` is a command placed before a new variable. It means
that this variable exists only inside the function and nowhere else. That
is, if you try to use a variable that had `local` in front of it outside
the function, you’ll get an error.

I also learned about code etiquette — specifically, global variables that
will appear throughout the code should be written in uppercase letters,
while variables inside functions should be lowercase, especially those
declared with `local`. This makes the code easier to read; it’s a kind of
tradition.

And the most interesting thing I learned is that an argument like `$1`
works differently inside a function. For example, if a function named
`days` contains the line `echo "Today is $1"` and you call the function
with `days Saturday`, it will output `Today is Saturday`. That means that
if you use `$1` inside a function, it doesn’t refer to the command‑line
argument from the user; instead, the argument is taken from when the
developer calls the function and writes an argument right in the code.

Now something really interesting: `curl` is basically a command to access
the internet — that’s literally what it means — and then come parameters.
We use the `-s` flag so that `curl` doesn’t print the status of the
request to the screen, doing everything silently. Next is the request
type. By default, it’s always `GET`, which means retrieving something from
the internet. If you need `GET` you don’t even have to write it — `curl`
will understand what is wanted. In our case, we are sending information to
a Telegram bot, so we use `-X POST`. Then come the specific parameters.
`url` — that’s self‑explanatory, the link to the bot via Telegram’s API
for sending messages, plus our bot token. Next comes `\` — that’s also new
for me. A backslash means that the same command continues on the next
line. It’s for convenience and readability, because we have three
parameters in a row. It looks nicer and is more practical to move them to
the next line. `-d` means that the specific parameters for the API service
we are sending information to will follow. We have standard and maximally
universal parameters for Telegram: `chat_id` — the ID of the chat with the
user we are sending the notification to; then `text` — the text will be
the argument we pass to the function when it is called later in the code;
and finally `parse_mode` — basically, the format in which we will send the
message to Telegram’s API. This will always be `HTML`. And the very end:
`> /dev/null 2>&1`. Here’s the trick: we redirect all output to null.
First we redirect stdout (standard output to the terminal) to nothing
using `>`, and then we specify `2>&1` — meaning redirect stderr (error
output) to the same place as stdout — i.e., to the trash, not to the
screen.

Next, two similar functions. The first one will output a number — the
percentage of disk space used on the computer. It is obtained by a
sequence of commands: first `df` with the root directory — the command
outputs the disk status, and among other parameters, it prints the
percentage full at the end. So we pipe the entire output to `tail`.
`tail` with the `-1` parameter outputs the last line of the previous
command’s output, so we get only one line that contains the disk‑usage
percentage. Then another pipe to `awk`. `awk` is essentially a more
powerful text editor in the shell. Here we use `'{print $5}'`, which means
“print only the fifth column” (these columns are easy to identify — for
example, `27 75 84 74792 74` — that’s five columns separated by spaces, so
`$5` here is `74`). Then we are left with something like `54%`, but we
need to remove the percent sign itself, so we pipe again to `sed`. `sed`
— here the `s` means substitution; then `/` are delimiters; `%` is what we
are changing; `//` means replace with nothing — which is equivalent to
deletion. Then the second, simpler function: here `df -h` — this flag
makes the output of the last line that contains the percentage more
human‑readable. Without `-h`, the terminal would print a huge, unreadable
number of bytes; with `-h`, the output is in units like G, M, K that are
more understandable to a normal person. And naturally, using `tail` we get
that last, more user‑friendly line — so this function holds a script that
outputs a more detailed disk status.

Another new thing: the `hostname` command — it simply returns your PC’s
network name.

Another cool thing: since we chose `parse_mode = HTML`, we can play around
with the text we send to the user. In my case, I made the main parameters
in the sent message stand out in bold. I did this by inserting `<b>` before
the text I want to highlight and `</b>` after it (for example, to highlight
the word `CODE`, you write `<b>CODE</b>`).

And finally, a reminder: `-ge` in a test means “greater than or equal to”.
