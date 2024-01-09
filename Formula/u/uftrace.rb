class Uftrace < Formula
  desc "Function graph tracer for CC++Rust"
  homepage "https:uftrace.github.ioslide"
  url "https:github.comnamhyunguftracearchiverefstagsv0.15.tar.gz"
  sha256 "c4f2a45687fd39dbde509635ebf094d7ed301793920f37bcaabb8161ff69f2fd"
  license "GPL-2.0-only"
  head "https:github.comnamhyunguftrace.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "37f182c9177e648bbb37a6738ad34a33482f40595f3be3adea4246cf415d8857"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit"
  depends_on "ncurses"
  depends_on "python@3.12"

  def install
    # TODO: Obsolete with git master, to be removed when updating to next release
    inreplace "miscversion.sh", "depshave_libpython2.7", "depshave_libpython*"

    python3 = "python3.12"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace Dir["check-depsMakefile{,.check}"], "pkg-config python3", "pkg-config python-#{pyver}"

    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "V=1"
  end

  test do
    out = shell_output("#{bin}uftrace -A . -R . -P main #{bin}uftrace -V")
    assert_match "dwarf", out
    assert_match "python", out
    assert_match "luajit", out
    assert_match "tui", out
    assert_match "sched", out
    assert_match "dynamic", out

    assert_match "| main() {", out
    assert_match "|   getopt_long(2, ", out
    assert_match "printf", out
    assert_match "| } * main *", out
  end
end