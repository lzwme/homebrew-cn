class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload24.01.0forgit-24.01.0.tar.gz"
  sha256 "29acc9133ba4b418f4addbabefbd451ad0b5c87e8136b90bba00d82eb35967fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "100b7822325507a6fdd604ce49ed15f2631f1447bcbc526a4f5cc92ad4d33ea7"
  end

  depends_on "fzf"

  def install
    bin.install "bingit-forgit"
    bash_completion.install "completionsgit-forgit.bash"
    inreplace "forgit.plugin.zsh", 'FORGIT="$INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}forgit.plugin.zsh
        #{opt_pkgshare}forgit.plugin.sh
    EOS
  end

  test do
    system "git", "init"
    (testpath"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end