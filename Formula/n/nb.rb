class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.20.0.tar.gz"
  sha256 "7d677e88ebeb64f9f94a78e0b08cc4d60146bdf2f591fcd6bf31f832eba55e08"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1137153eb724d3518bc346355bab19bb0e4272223a9c47c92fd749bddb0730a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1137153eb724d3518bc346355bab19bb0e4272223a9c47c92fd749bddb0730a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1137153eb724d3518bc346355bab19bb0e4272223a9c47c92fd749bddb0730a"
    sha256 cellar: :any_skip_relocation, sonoma:        "caca87987f57de4883413dad8a52eade0bffa8207688e7ccc2a392801cf59a76"
    sha256 cellar: :any_skip_relocation, ventura:       "caca87987f57de4883413dad8a52eade0bffa8207688e7ccc2a392801cf59a76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1137153eb724d3518bc346355bab19bb0e4272223a9c47c92fd749bddb0730a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1137153eb724d3518bc346355bab19bb0e4272223a9c47c92fd749bddb0730a"
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