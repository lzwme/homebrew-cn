class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.18.1.tar.gz"
  sha256 "0987af3509d0e7f1ebfb37f75b090e2475a423fbfd7e957bb8f023b6cd054b15"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3cc1d2c55baa403321ec065f3ddf3e5ffc3381d9ace622a370968ceb88947ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3cc1d2c55baa403321ec065f3ddf3e5ffc3381d9ace622a370968ceb88947ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3cc1d2c55baa403321ec065f3ddf3e5ffc3381d9ace622a370968ceb88947ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17b46738352fc8c651614f1f68836681ba5b96ed8874fab56d6e94716a660f6"
    sha256 cellar: :any_skip_relocation, ventura:       "c17b46738352fc8c651614f1f68836681ba5b96ed8874fab56d6e94716a660f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3cc1d2c55baa403321ec065f3ddf3e5ffc3381d9ace622a370968ceb88947ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3cc1d2c55baa403321ec065f3ddf3e5ffc3381d9ace622a370968ceb88947ea"
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