class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https:github.comwfxrforgit"
  url "https:github.comwfxrforgitreleasesdownload23.09.0forgit-23.09.0.tar.gz"
  sha256 "258c3211542933c11f7b7f521d4a2ab79dda35580627ef7083195d3bbce0a4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ff2f5456050d6a95d28c71fb93247d71553620fdfe3dec197777f119cb91d82"
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