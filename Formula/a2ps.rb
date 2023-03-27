class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.3.tar.gz"
  sha256 "d00e81e0eb4dcbf2d4963d89e1df2bb66f71e66d73b4152c43cf9838e6aaf7c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "286151bd3ac11ed7236dae1c32107560e976ab6283ca0512de3ff3dcb54ba840"
    sha256 arm64_monterey: "a3e581417c271087217bddae7c41e186791e445425d9e5e69886c0ff69ac2fc8"
    sha256 arm64_big_sur:  "610389285d270fcbfbc378254b4ed87825a8ea68b351348f12548958d6f36771"
    sha256 ventura:        "63d06cf7e978d2683f8edb8f3a064b911c6a092127eae6065bbaf1a3977f5fdf"
    sha256 monterey:       "b1019c9b31a42441a149e5e33a555500f42ac050c1f9540dc2a25f9e173f89f5"
    sha256 big_sur:        "502ca02498f3781c2920c2bebb97c5719cb22a01630518792507e3bdffa08f53"
    sha256 x86_64_linux:   "14d8d6816b1429db55f8012c07253aebfba582ae1cf0daf4b7fc7eb5aeb13d20"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end