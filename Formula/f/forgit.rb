class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload24.01.0forgit-24.01.0.tar.gz"
  sha256 "29acc9133ba4b418f4addbabefbd451ad0b5c87e8136b90bba00d82eb35967fa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "43bce62f9fa1359c94c1ef9c0d6604aa6d1c5e6df62bd06d131dd21288eafb98"
  end

  depends_on "fzf"

  def install
    bin.install "bingit-forgit"
    bash_completion.install "completionsgit-forgit.bash" => "git-forgit"
    zsh_completion.install "completionsgit-forgit.zsh" => "_git-forgit"
    inreplace "forgit.plugin.zsh", 'FORGIT="$INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    inreplace "conf.dforgit.plugin.fish",
              'set -x FORGIT "$FORGIT_INSTALL_DIRbingit-forgit"',
              "set -x FORGIT \"#{opt_prefix}bingit-forgit\""
    pkgshare.install "conf.dforgit.plugin.fish"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}forgit.plugin.zsh
        #{opt_pkgshare}forgit.plugin.sh
        #{opt_pkgshare}forgit.plugin.fish
    EOS
  end

  test do
    system "git", "init"
    (testpath"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end