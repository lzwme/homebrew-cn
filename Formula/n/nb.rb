class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.19.0.tar.gz"
  sha256 "a1f7c6d8832a10161d5e05e91410564371f6bac9f4c9a10a02b1ecd23b6bc623"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c82fbe5089614a1bcc9bd876ed3dd5b544359a33fa9b1fdbb4588ce38f991c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c82fbe5089614a1bcc9bd876ed3dd5b544359a33fa9b1fdbb4588ce38f991c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30c82fbe5089614a1bcc9bd876ed3dd5b544359a33fa9b1fdbb4588ce38f991c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce374d8304d0945ae6aa2925e27e56d0a334ab018d5bef3fefd6f68d2bd8c91"
    sha256 cellar: :any_skip_relocation, ventura:       "cce374d8304d0945ae6aa2925e27e56d0a334ab018d5bef3fefd6f68d2bd8c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c82fbe5089614a1bcc9bd876ed3dd5b544359a33fa9b1fdbb4588ce38f991c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30c82fbe5089614a1bcc9bd876ed3dd5b544359a33fa9b1fdbb4588ce38f991c"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "binbookmark"

    bash_completion.install "etcnb-completion.bash" => "nb"
    zsh_completion.install "etcnb-completion.zsh" => "_nb"
    fish_completion.install "etcnb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}nb version")

    system "yes | #{bin}nb notebooks init"
    system bin"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}nb ls")
    assert_match "test note", shell_output("#{bin}nb show 1")
    assert_match "1", shell_output("#{bin}nb search test")
  end
end