class Uftrace < Formula
  desc "Function graph tracer for CC++Rust"
  homepage "https:uftrace.github.ioslide"
  url "https:github.comnamhyunguftracearchiverefstagsv0.17.tar.gz"
  sha256 "04d560011c7587eddedcc674677cbef9ddc0ace449601d4b355e78589b16134f"
  license "GPL-2.0-only"
  head "https:github.comnamhyunguftrace.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "1403c9e2ac729fcb07b71e4a376d3b2824df0d7017e4266cf8bbd147e58d9160"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "elfutils"
  depends_on "libunwind"
  depends_on :linux
  depends_on "luajit"
  depends_on "ncurses"
  depends_on "python@3.13"

  def install
    # TODO: Obsolete with git master, to be removed when updating to next release
    inreplace "miscversion.sh", "depshave_libpython2.7", "depshave_libpython*"

    python3 = "python3.13"
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace Dir["check-depsMakefile{,.check}"], "pkg-config python3", "pkg-config python-#{pyver}"

    system ".configure", "--disable-silent-rules", *std_configure_args
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