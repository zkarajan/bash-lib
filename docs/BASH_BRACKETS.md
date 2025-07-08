<!--
  BASH BRACKETS: (), {}, $(), [], [[]]
  Оформлено максимально близко к оригинальному скрину sysxplore.com
-->

<style>
.bracket-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  font-family: 'Fira Mono', 'Consolas', 'Menlo', monospace;
}
.bracket-card {
  background: #23272e;
  border-radius: 10px;
  box-shadow: 0 2px 8px #0004;
  color: #e6e6e6;
  padding: 18px 18px 10px 18px;
  min-width: 320px;
  max-width: 340px;
  flex: 1 1 320px;
  margin-bottom: 0;
}
.bracket-title {
  font-size: 1.1em;
  font-weight: bold;
  color: #7de2fc;
  margin-bottom: 6px;
  letter-spacing: 1px;
}
.bracket-desc {
  color: #bdbdbd;
  font-size: 0.98em;
  margin-bottom: 8px;
}
.bracket-emoji {
  font-size: 1.1em;
  margin-right: 2px;
}
.code-block {
  background: #181a20;
  border-radius: 6px;
  padding: 10px 12px;
  font-size: 0.98em;
  margin: 0 0 0.5em 0;
  color: #e6e6e6;
}
</style>

<h1 style="color:#7de2fc; font-size:2.1em; letter-spacing:2px; margin-bottom:0.2em;">BASH BRACKETS: <span style="color:#fff;">(), {}, $(), [], [[ ]]</span></h1>
<p style="color:#bdbdbd; margin-top:0; margin-bottom:1.5em; font-size:1.1em;">by sysxplore.com</p>

<div class="bracket-grid">

<!-- $() -->
<div class="bracket-card">
  <div class="bracket-title">$(commands)</div>
  <div class="bracket-desc">Executes a command and captures its output. <a href="https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html" style="color:#7de2fc;">Command substitution</a> allows the result of a command (in this case, <code>grep</code>) to be stored in a variable.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>log_file="/var/log/syslog"
keyword="error"
output=$(grep "$keyword" "$log_file")</pre></div>
</div>

<!-- { list; } -->
<div class="bracket-card">
  <div class="bracket-title">{ list; }</div>
  <div class="bracket-desc">Executes a group of commands in the same <b>shell process</b>. Curly braces group commands together to be executed sequentially in the current environment.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>sudo apt install exa
exa
echo "Listed files using exa"; }</pre></div>
</div>

<!-- ( a b c ) -->
<div class="bracket-card">
  <div class="bracket-title">( a b c )</div>
  <div class="bracket-desc">Creates an array of values. Parentheses are used to define an array, allowing multiple elements to be stored in one variable.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>files=(log.txt log2.txt log3.txt)
for file in "${files[@]}"; do
  echo "Processing $file"
done</pre></div>
</div>

<!-- ( list ) -->
<div class="bracket-card">
  <div class="bracket-title">( list )</div>
  <div class="bracket-desc">Executes a list of commands in a separate <b>subshell</b>. The commands inside the parentheses run in a child process, isolated from the main shell.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>( cd /home/user
  ls
  whoami )</pre></div>
</div>

<!-- {range} -->
<div class="bracket-card">
  <div class="bracket-title">{range}</div>
  <div class="bracket-desc">Expands to multiple strings. Brace expansion is a powerful way to generate sequences or multiple strings, useful for <b>batch operations</b>. The range can be numbers or characters.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>for file in backup_{1..4}.tar.gz; do
  mv $file /var/oldbackups
done</pre></div>
</div>

<!-- ${expression} -->
<div class="bracket-card">
  <div class="bracket-title">${expression}</div>
  <div class="bracket-desc">Modifies variable content. <b>Parameter expansion</b> allows you to alter a variable's value, such as changing a file extension from .txt to .bak.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>filename="report.txt"
backup_file="${filename%.txt}.bak"
echo "Backup file: $backup_file"</pre></div>
</div>

<!-- $variable -->
<div class="bracket-card">
  <div class="bracket-title">$variable</div>
  <div class="bracket-desc">Accesses a variable's value. This is another way to <b>reference</b> a variable, commonly used when you need to follow it with additional characters or text.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>username="John"
greeting="Hello, ${username}!"
echo "$greeting"</pre></div>
</div>

<!-- $((expression)) -->
<div class="bracket-card">
  <div class="bracket-title">$((expression))</div>
  <div class="bracket-desc">Performs <b>arithmetic calculations</b>. The double parentheses are used for math operations, such as addition, multiplication, etc.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>num1=5
num2=3
result=$((num1 * num2 + 1))</pre></div>
</div>

<!-- [ expression ] -->
<div class="bracket-card">
  <div class="bracket-title">[ expression ]</div>
  <div class="bracket-desc">Tests a condition using single brackets. The <b>[]</b> denotes a <b>test command</b> that checks conditions, such as whether a file exists.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>file="/etc/passwd"
if [ -f "$file" ]; then
  echo "File exists"
fi</pre></div>
</div>

<!-- [[ expression ]] -->
<div class="bracket-card">
  <div class="bracket-title">[[ expression ]]</div>
  <div class="bracket-desc">Tests a condition using double brackets. Double brackets are more flexible in Bash, supporting <b>advanced pattern matching</b> and logical operators.</div>
  <div class="bracket-emoji">🔴🟢🟡</div>
  <div class="code-block"><pre>user=$USER
if [[ $user == "root" ]]; then
  echo "You are the root user"
fi</pre></div>
</div>

</div>

<p style="color:#bdbdbd; font-size:0.95em; margin-top:2em;">Источник: <a href="https://sysxplore.com" style="color:#7de2fc;">sysxplore.com</a></p>
