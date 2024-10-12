class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.14.3.tar.gz"
  sha256 "3aa61b50146aff15399bdb4d5cb050620680ab6b5b68190d7d0f80fd4fb773dc"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f12c46d48840e4b0b4436c6d542ab921cd9acbc0b72955279fe988ad9d2f8f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f12c46d48840e4b0b4436c6d542ab921cd9acbc0b72955279fe988ad9d2f8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f12c46d48840e4b0b4436c6d542ab921cd9acbc0b72955279fe988ad9d2f8f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e24896f5e0471528d84d8692d08dcdfdd6f93c7316fb6e52ffd43dce0ed9e43d"
    sha256 cellar: :any_skip_relocation, ventura:       "e24896f5e0471528d84d8692d08dcdfdd6f93c7316fb6e52ffd43dce0ed9e43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f12c46d48840e4b0b4436c6d542ab921cd9acbc0b72955279fe988ad9d2f8f4"
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

    bash_completion.install "etcnb-completion.bash" => "nb.bash"
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