class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https:github.comelasticdogtranscrypt"
  url "https:github.comelasticdogtranscryptarchiverefstagsv2.3.1.tar.gz"
  sha256 "c5f5af35016474ffd1f8605be1eac2e2f17743737237065657e3759c8d8d1a66"
  license "MIT"
  head "https:github.comelasticdogtranscrypt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c796653e0de06fc0a443b591892bd9ad29771a810673a6165d47a61c36c9d157"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "vim" # needed for xxd
  end

  def install
    bin.install "transcrypt"
    man1.install "mantranscrypt.1"
    bash_completion.install "contribbashtranscrypt"
    zsh_completion.install "contribzsh_transcrypt"
  end

  test do
    system "git", "init"
    system bin"transcrypt", "--password", "guest", "--yes"

    (testpath".gitattributes").atomic_write <<~EOS
      sensitive_file  filter=crypt diff=crypt merge=crypt
    EOS
    (testpath"sensitive_file").write "secrets"
    system "git", "add", ".gitattributes", "sensitive_file"
    system "git", "commit", "--message", "Add encrypted version of file"

    assert_equal `git show HEAD:sensitive_file --no-textconv`.chomp,
                 "U2FsdGVkX198ELlOY60n2ekOK1DiMCLS1dRs53RGBeU="
  end
end