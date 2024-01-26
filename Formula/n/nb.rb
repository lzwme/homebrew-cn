class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.10.2.tar.gz"
  sha256 "41755faefa8c0159f8ac81dac553ed900f6063afe266a2fe60f5bd74970f4632"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18969c2e8f4e130b61eda52d78e5b620a057cb01c6ff4b90da1b7d0ac29364a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18969c2e8f4e130b61eda52d78e5b620a057cb01c6ff4b90da1b7d0ac29364a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18969c2e8f4e130b61eda52d78e5b620a057cb01c6ff4b90da1b7d0ac29364a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4b4efe41519ee903078fe1b50353cfb104ce7537f3bd6302a4ecdbc58b6c7a2"
    sha256 cellar: :any_skip_relocation, ventura:        "b4b4efe41519ee903078fe1b50353cfb104ce7537f3bd6302a4ecdbc58b6c7a2"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b4efe41519ee903078fe1b50353cfb104ce7537f3bd6302a4ecdbc58b6c7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18969c2e8f4e130b61eda52d78e5b620a057cb01c6ff4b90da1b7d0ac29364a4"
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