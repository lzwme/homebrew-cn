class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.18.0.tar.gz"
  sha256 "7bcf153933d071e157b36846a00a7a2cee4b5066289968803b88b8e33f54ab5f"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4615634ddfad9d1846d30af0705cb403a9f37532f07040d8cb9892ad26714139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4615634ddfad9d1846d30af0705cb403a9f37532f07040d8cb9892ad26714139"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4615634ddfad9d1846d30af0705cb403a9f37532f07040d8cb9892ad26714139"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffc5aa7d8a5325d94b28c59ae9e2d4716cf28f8424ebf7c51f2bfc5adf3ab68"
    sha256 cellar: :any_skip_relocation, ventura:       "4ffc5aa7d8a5325d94b28c59ae9e2d4716cf28f8424ebf7c51f2bfc5adf3ab68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4615634ddfad9d1846d30af0705cb403a9f37532f07040d8cb9892ad26714139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4615634ddfad9d1846d30af0705cb403a9f37532f07040d8cb9892ad26714139"
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