class Grc < Formula
  include Language::Python::Shebang

  desc "Colorize logfiles and command output"
  homepage "https:kassiopeia.juls.savba.sk~garabiksoftwaregrc.html"
  url "https:github.comgarabikgrcarchiverefstagsv1.13.tar.gz"
  sha256 "a7b10d4316b59ca50f6b749f1d080cea0b41cb3b7258099c3eb195659d1f144f"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comgarabikgrc.git", branch: "devel"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "c53a320fd40831dbfd74a3add881c94b5d8bca074b6826c190f35c1a3316d96d"
  end

  depends_on "python@3.13"

  def install
    # fix non-standard prefix installs
    inreplace "grc", "usrlocaletc", "#{etc}"
    inreplace "grc.1", " etc", " #{etc}"
    inreplace ["grcat", "grcat.1"], "usrlocalsharegrc", "#{pkgshare}"

    # so that the completions don't end up in etcprofile.d
    inreplace "install.sh",
      "mkdir -p $PROFILEDIR\ncp -fv grc.sh $PROFILEDIR", ""

    rewrite_shebang detected_python_shebang, "grc", "grcat"

    system ".install.sh", prefix, HOMEBREW_PREFIX
    etc.install "grc.sh"
    etc.install "grc.zsh"
    etc.install "grc.fish"
    zsh_completion.install "_grc"
  end

  test do
    actual = pipe_output("#{bin}grcat #{pkgshare}conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end