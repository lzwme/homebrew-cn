class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  sha256 "7bcd5d001916f3a50ed7436f4f700e3d2b1bade3ed803219c592d62502a57363"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f12265a7c9b810622a120fd397fed95c5b8d4f690df105f842a227f0e6be8f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f12265a7c9b810622a120fd397fed95c5b8d4f690df105f842a227f0e6be8f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f12265a7c9b810622a120fd397fed95c5b8d4f690df105f842a227f0e6be8f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a20b687cb4ce1878faa361fa1fc4c466b9450a027a6875cfa982ab754d4206c1"
    sha256 cellar: :any_skip_relocation, ventura:       "a20b687cb4ce1878faa361fa1fc4c466b9450a027a6875cfa982ab754d4206c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146d9b404292ff71f731bac5517d404fd541a6483c0ecbf334eacf35d3cb0d18"
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

  conflicts_with "gnome-common", because: "both install ax_check_enable_debug.m4 and ax_code_coverage.m4"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"configure.ac").write <<~EOS
      AC_INIT([test], [0.1])
      AX_CHECK_ENABLE_DEBUG
      AC_OUTPUT
    EOS

    system Formula["autoconf"].bin/"autoconf", "configure.ac"
    assert_path_exists testpath/"autom4te.cache"
  end
end