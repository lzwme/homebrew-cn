class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.14.0.tar.gz"
  sha256 "8000372d30907a04be1c12a2ddba43df3a8122fe74206411729ce28a602d1fa3"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "edf8b2e37b7996720299a8e0179f63c32a937043cd2062e456dfd402771d496b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edf8b2e37b7996720299a8e0179f63c32a937043cd2062e456dfd402771d496b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edf8b2e37b7996720299a8e0179f63c32a937043cd2062e456dfd402771d496b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf8b2e37b7996720299a8e0179f63c32a937043cd2062e456dfd402771d496b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c625e3d7f831242756fe4614176e2cdaff0fd26089b0db2c07d9e5c2df2eb833"
    sha256 cellar: :any_skip_relocation, ventura:        "c625e3d7f831242756fe4614176e2cdaff0fd26089b0db2c07d9e5c2df2eb833"
    sha256 cellar: :any_skip_relocation, monterey:       "c625e3d7f831242756fe4614176e2cdaff0fd26089b0db2c07d9e5c2df2eb833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf8b2e37b7996720299a8e0179f63c32a937043cd2062e456dfd402771d496b"
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