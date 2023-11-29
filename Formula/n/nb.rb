class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.9.0.tar.gz"
  sha256 "213c1138d9a87ebc4e0e6e956cf19812d10e8ddd2373fd97cab15437a46e6f1b"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e530279b22726670487cb28f54870d6ae920b0fb9a03aa719d266f8bc62de62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e530279b22726670487cb28f54870d6ae920b0fb9a03aa719d266f8bc62de62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e530279b22726670487cb28f54870d6ae920b0fb9a03aa719d266f8bc62de62"
    sha256 cellar: :any_skip_relocation, sonoma:         "32a35cafd1b419db7e4fbf26faef901f571dc07e863241562f335082bcc1ba2b"
    sha256 cellar: :any_skip_relocation, ventura:        "32a35cafd1b419db7e4fbf26faef901f571dc07e863241562f335082bcc1ba2b"
    sha256 cellar: :any_skip_relocation, monterey:       "32a35cafd1b419db7e4fbf26faef901f571dc07e863241562f335082bcc1ba2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e530279b22726670487cb28f54870d6ae920b0fb9a03aa719d266f8bc62de62"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}/nb version")

    system "yes | #{bin}/nb notebooks init"
    system bin/"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}/nb ls")
    assert_match "test note", shell_output("#{bin}/nb show 1")
    assert_match "1", shell_output("#{bin}/nb search test")
  end
end