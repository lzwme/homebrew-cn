class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.15.0.tar.gz"
  sha256 "4168df4396ecea1a6fbc6376e8269ee93f0c7f15bcc57256d811d583db28f267"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab9f3b222b95466ec41af9a53fb4bba0da24a3ae636f634d0d51e6c67f8e8a4"
    sha256 cellar: :any_skip_relocation, ventura:       "fab9f3b222b95466ec41af9a53fb4bba0da24a3ae636f634d0d51e6c67f8e8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
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