class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https:launchpad.netbyobu"
  url "https:launchpad.netbyobutrunk5.133+downloadbyobu_5.133.orig.tar.gz"
  sha256 "4d8ea48f8c059e56f7174df89b04a08c32286bae5a21562c5c6f61be6dab7563"
  license "GPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03b4147cf768eb8069102dbae06173cb819552e3ec9c3b1dab31b03ce052a27b"
  end

  head do
    url "https:github.comdustinkirklandbyobu.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gettext"
  depends_on "newt"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    if build.head?
      cp ".debianchangelog", ".ChangeLog"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system ".configure", *std_configure_args
    system "make", "install"

    byobu_python = Formula["newt"].deps
                                  .find { |d| d.name.match?(^python@\d\.\d+$) }
                                  .to_formula
                                  .libexec"binpython"

    lib.glob("byobuinclude*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(binbyobu_script)
      (binbyobu_script).write_env_script(libexecbyobu_script, BYOBU_PYTHON: byobu_python)
    end
  end

  test do
    system bin"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}byobu-select-session 2>&1", 1)
  end
end