class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://ghproxy.com/https://github.com/wfxr/forgit/releases/download/23.08.0/forgit-23.08.0.tar.gz"
  sha256 "9b7ba81a6b5182fd0f89116459c8fdc83e4d169b8a76d3cfcef566c536dc42b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, ventura:        "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, monterey:       "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17459e6266f66664381b6e3f1c9adf8fd02ba280c3282b87b3ebf80f915efa8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5cf7c49e779c6e787548f2bdc17dbddfea10c0b0b417a01ecd70cf67f6d1b70"
  end

  depends_on "fzf"

  def install
    bin.install "bin/git-forgit"
    bash_completion.install "completions/git-forgit.bash"
    inreplace "forgit.plugin.zsh", 'FORGIT="$INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}/forgit.plugin.zsh
        #{opt_pkgshare}/forgit.plugin.sh
    EOS
  end

  test do
    system "git", "init"
    (testpath/"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end