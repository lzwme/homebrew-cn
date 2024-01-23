class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.10.1.tar.gz"
  sha256 "0d37414563fdb743a6ae5052940b9dcbfc60420807f3888b7f089afea2e8e962"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84a05ff41fabf4758f7e74f987fec34fe89e73f0f9357d595d9029cca0249795"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84a05ff41fabf4758f7e74f987fec34fe89e73f0f9357d595d9029cca0249795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84a05ff41fabf4758f7e74f987fec34fe89e73f0f9357d595d9029cca0249795"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ef37c3405ae55adc64a11fd975fc8046530822c454465abc590afccdd0de222"
    sha256 cellar: :any_skip_relocation, ventura:        "6ef37c3405ae55adc64a11fd975fc8046530822c454465abc590afccdd0de222"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef37c3405ae55adc64a11fd975fc8046530822c454465abc590afccdd0de222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a05ff41fabf4758f7e74f987fec34fe89e73f0f9357d595d9029cca0249795"
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