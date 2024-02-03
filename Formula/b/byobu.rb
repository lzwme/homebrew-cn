class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https:github.comdustinkirklandbyobu"
  url "https:github.comdustinkirklandbyobuarchiverefstags6.10.tar.gz"
  sha256 "55ad76dbe1bf5be183e4742cd3bdbf1b7cf5468339de35ceb9cfdd05709e8dba"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "355c2e08500664375925c2e2e827d390793cacc76bd4995ad9d6b55096c91c17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "newt"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    cp ".debianchangelog", ".ChangeLog"
    system "autoreconf", "--force", "--install", "--verbose"
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