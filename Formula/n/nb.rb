class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.11.0.tar.gz"
  sha256 "20582072c36da3c4f05a53634cea4470464266e6b764b06828b297ca16743800"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb6ee968ad80f2f60723b972f9a556a96b2e2e506425ffc19c600ec8a0afcce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6ee968ad80f2f60723b972f9a556a96b2e2e506425ffc19c600ec8a0afcce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6ee968ad80f2f60723b972f9a556a96b2e2e506425ffc19c600ec8a0afcce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe6f69ad6c13ce17ce7b7cbd09478fc701e05f2c509326a3a7ee175c20cbab36"
    sha256 cellar: :any_skip_relocation, ventura:        "fe6f69ad6c13ce17ce7b7cbd09478fc701e05f2c509326a3a7ee175c20cbab36"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6f69ad6c13ce17ce7b7cbd09478fc701e05f2c509326a3a7ee175c20cbab36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6ee968ad80f2f60723b972f9a556a96b2e2e506425ffc19c600ec8a0afcce4"
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