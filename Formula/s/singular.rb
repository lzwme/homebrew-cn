class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p4.tar.gz"
  version "4.3.2p4"
  sha256 "22f263665e7e6def39f48fd2695f613a377281af39350414f461ba7f3bd07149"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match versions from directories
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v.tr("-", ".")) }
                     .reject { |v| v.patch >= 90 }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Fetch the page for the newest version directory
      dir_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join(@url, "#{newest_version.to_s.tr(".", "-")}/").to_s,
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(/href=.*?singular[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i).flatten

      dir_versions || versions
    end
  end

  bottle do
    sha256 arm64_ventura:  "c368b9af9eff41fb0fb9fbaedd94928dd94577a68f44d29b33736d026dedde07"
    sha256 arm64_monterey: "a17bd0521171d71f41778d0f40a2d856a8a2be5f1803ec8427d69b8b8f1a8bbb"
    sha256 arm64_big_sur:  "bebefcd3cedc588bbf49b0331ffa258f76f3a086b747ac8a37aeefe23cea6579"
    sha256 ventura:        "2db420d3b13cca63246b9f0cc7c19cc2dea9b5bb88ddcd164a0ee5ab88fdd224"
    sha256 monterey:       "8ce57a093dfe5ece45cd44383e1203805089277d39dd04277c1f7c322061cc6d"
    sha256 big_sur:        "e8cbd14ce43876fd5720f6d8306d3a1f5c66497af4a437fcd8d3a18607c7b62f"
    sha256 x86_64_linux:   "23bbcc5e0f26babfafa5b35a78146fbd370c80a39e7c697f795cb35d0a63b873"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.11"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system "./autogen.sh" if build.head? || OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{which("python3.11")}",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end