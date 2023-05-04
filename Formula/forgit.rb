class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://ghproxy.com/https://github.com/wfxr/forgit/releases/download/23.04.0/forgit-23.04.0.tar.gz"
  sha256 "89826d12b551829c4bce396551b1505c0604ba29130f4b8e2f842c2ca0b4c9e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd4754e370b3a0aad8afdf03901f14e5263b893dc87fe6e1b31d008df2b03694"
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