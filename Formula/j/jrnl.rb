class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/04/59/c15befa8f1a6ff159af29d86c1abc50135e4f8768afe5a1621930e21a0d8/jrnl-4.0.1.tar.gz"
  sha256 "f3b17c4b040af44fde053ae501832eb313f2373d1b3b1a82564a8214d223ede8"
  license "GPL-3.0-only"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b5711ff07f367d12ff9d5e0ef6c773620a5fb082795b49818da35c7bf2993cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60eda1430b934b9a5b726a545664779905530268066de3ae272ce76a8b115dda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f33cbb9662d5a6ac0ec1d74374e89e2d1e37f430a8f20ef3013271f679b8c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fc47b56b684cb3c089eaa6a8b53e697e3e12317ea3e3e42f02aec03c3d722eb"
    sha256 cellar: :any_skip_relocation, ventura:        "51fee7bd6710265124065109f92ce18824db36d73aa354fb3ad0d642a7257084"
    sha256 cellar: :any_skip_relocation, monterey:       "1c09a222f0b63341103d543562f212884f97b04879139c3884c97bf397d7fc4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b05373117dd8c5108644f2d20c230dfe989b266fc9ad608a687ff0ed9438717b"
  end

  depends_on "cffi"
  depends_on "keyring"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "ansiwrap" do
    url "https://files.pythonhosted.org/packages/7c/45/2616341cfcace37d4619d5106a85fcc24f2170d1a161bc5f7fdb81772fbc/ansiwrap-0.8.4.zip"
    sha256 "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/65/40/34c5fe13ef544ed241fb2dd621d0160c065652a0575137b5ad66e5b279c8/ruamel.yaml-0.18.2.tar.gz"
    sha256 "9bce33f7a814cea4c29a9c62fe872d2363d6220b767891d956eacea8fa5e6fe8"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "textwrap3" do
    url "https://files.pythonhosted.org/packages/4d/02/cef645d4558411b51700e3f56cefd88f05f05ec1b8fa39a3142963f5fcd2/textwrap3-0.9.2.zip"
    sha256 "5008eeebdb236f6303dcd68f18b856d355f6197511d952ba74bc75e40e0c3414"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  # Support python 3.12. Patch is from upstream commit but does not apply.
  # https://github.com/jrnl-org/jrnl/commit/cb69bb474c55aa013e7c816f01fe25c1224c94fe
  patch :DATA

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    (testpath/"tests.sh").write <<~EOS
      #!/usr/bin/env expect

      set timeout 3
      match_max 100000

      spawn "#{bin}/jrnl" --encrypt
      expect -exact "Enter password for journal 'default': "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Enter password again: "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Do you want to store the password in your keychain? \\[Y/n\\] "
      send -- "n\\r"
      expect -re "Journal encrypted to .*"
      expect eof
    EOS

    # Write the journal
    input = "#{testpath}/journal.txt\nn\nn"
    assert_match "Journal 'default' created", pipe_output("#{bin}/jrnl My journal entry 2>&1", input, 0)
    assert_predicate testpath/"journal.txt", :exist?

    # Read the journal
    assert_match "#{testpath}/journal.txt", shell_output("#{bin}/jrnl --list 2>&1")

    # Encrypt the journal. Needs a TTY to read password.
    system "expect", "./tests.sh"
    assert_predicate testpath/".config/jrnl/jrnl.yaml", :exist?
    assert_match "encrypt: true", (testpath/".config/jrnl/jrnl.yaml").read
  end
end

__END__
diff --git a/jrnl/journals/Entry.py b/jrnl/journals/Entry.py
index 5b35d7346..6c45303eb 100644
--- a/jrnl/journals/Entry.py
+++ b/jrnl/journals/Entry.py
@@ -7,10 +7,9 @@
 import re
 from typing import TYPE_CHECKING

-import ansiwrap
-
 from jrnl.color import colorize
 from jrnl.color import highlight_tags_with_background_color
+from jrnl.output import wrap_with_ansi_colors

 if TYPE_CHECKING:
     from .Journal import Journal
@@ -129,7 +128,7 @@ def pprint(self, short: bool = False) -> str:
                     columns = 79

             # Color date / title and bold title
-            title = ansiwrap.fill(
+            title = wrap_with_ansi_colors(
                 date_str
                 + " "
                 + highlight_tags_with_background_color(
@@ -143,35 +142,17 @@ def pprint(self, short: bool = False) -> str:
             body = highlight_tags_with_background_color(
                 self, self.body.rstrip(" \n"), self.journal.config["colors"]["body"]
             )
-            body_text = [
-                colorize(
-                    ansiwrap.fill(
-                        line,
-                        columns,
-                        initial_indent=indent,
-                        subsequent_indent=indent,
-                        drop_whitespace=True,
-                    ),
-                    self.journal.config["colors"]["body"],
-                )
-                or indent
-                for line in body.rstrip(" \n").splitlines()
-            ]
-
-            # ansiwrap doesn't handle lines with only the "\n" character and some
-            # ANSI escapes properly, so we have this hack here to make sure the
-            # beginning of each line has the indent character and it's colored
-            # properly. textwrap doesn't have this issue, however, it doesn't wrap
-            # the strings properly as it counts ANSI escapes as literal characters.
-            # TL;DR: I'm sorry.
-            body = "\n".join(
-                [
+
+            body = wrap_with_ansi_colors(body, columns - len(indent))
+            if indent:
+                # Without explicitly colorizing the indent character, it will lose its
+                # color after a tag appears.
+                body = "\n".join(
                     colorize(indent, self.journal.config["colors"]["body"]) + line
-                    if not ansiwrap.strip_color(line).startswith(indent)
-                    else line
-                    for line in body_text
-                ]
-            )
+                    for line in body.splitlines()
+                )
+
+            body = colorize(body, self.journal.config["colors"]["body"])
         else:
             title = (
                 date_str
diff --git a/jrnl/output.py b/jrnl/output.py
index 2d7064cb3..0230244bc 100644
--- a/jrnl/output.py
+++ b/jrnl/output.py
@@ -131,3 +131,12 @@ def format_msg_text(msg: Message) -> Text:
     text = textwrap.dedent(text)
     text = text.strip()
     return Text(text)
+
+
+def wrap_with_ansi_colors(text: str, width: int) -> str:
+    richtext = Text.from_ansi(text, no_wrap=False, tab_size=None)
+
+    console = Console(width=width)
+    with console.capture() as capture:
+        console.print(richtext, sep="", end="")
+    return capture.get()