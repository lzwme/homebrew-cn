class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://ghproxy.com/https://github.com/tj/git-extras/archive/refs/tags/7.1.0.tar.gz"
  sha256 "e5c855361d2f1ec1be6ee601247153d9c8c04a221949b6ec3903b32fa736f542"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, ventura:        "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, monterey:       "6490784e1856994d585dfc937e3866bfc45f124ae724eaebc727bbe8a173740d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f7ae4a6652f41107a9e038ccaeef053ca6074a81c3213e7381c6b6d5a05970"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-sync",
    because: "both install a `git-sync` binary"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end