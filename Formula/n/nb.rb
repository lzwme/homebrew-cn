class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.14.6.tar.gz"
  sha256 "6915bb40e9416f2ab9751e566ead3167e8470a81fc1200bdd12f504e145e9e4d"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cf01c32b0b42019926036d006e2d78d0a4a0a43093b6a8be0d505ba096c698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0cf01c32b0b42019926036d006e2d78d0a4a0a43093b6a8be0d505ba096c698"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0cf01c32b0b42019926036d006e2d78d0a4a0a43093b6a8be0d505ba096c698"
    sha256 cellar: :any_skip_relocation, sonoma:        "53aa02c1ddef8179cd9413b4fce4961b8d7058a24e35569136d00e335adf5b75"
    sha256 cellar: :any_skip_relocation, ventura:       "53aa02c1ddef8179cd9413b4fce4961b8d7058a24e35569136d00e335adf5b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0cf01c32b0b42019926036d006e2d78d0a4a0a43093b6a8be0d505ba096c698"
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