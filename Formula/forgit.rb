class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://ghproxy.com/https://github.com/wfxr/forgit/releases/download/23.07.0/forgit-23.07.0.tar.gz"
  sha256 "90d71f60e20c3d9f2776118c4ddb4712b4154ad1cdb0648d3d691740fa351985"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3bdbdf309091eaec6d3053ad31da773234bad78eef3de0000f41799a35f6a26"
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