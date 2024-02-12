class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.12.0.tar.gz"
  sha256 "ef196ebc4db6d6d038faeea9dcaac66569df3b7270249310e3dcd19fe71d6adb"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80441c0cffea358253f6f84ee0ef3ecf4abffacd3d3cb983193dc62a4bd26b7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80441c0cffea358253f6f84ee0ef3ecf4abffacd3d3cb983193dc62a4bd26b7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80441c0cffea358253f6f84ee0ef3ecf4abffacd3d3cb983193dc62a4bd26b7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef3f218b8c422838ad0c0bc11c6c31a23713d0d94fa3af1d57e746fb5bd6c993"
    sha256 cellar: :any_skip_relocation, ventura:        "ef3f218b8c422838ad0c0bc11c6c31a23713d0d94fa3af1d57e746fb5bd6c993"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3f218b8c422838ad0c0bc11c6c31a23713d0d94fa3af1d57e746fb5bd6c993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80441c0cffea358253f6f84ee0ef3ecf4abffacd3d3cb983193dc62a4bd26b7d"
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