class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p4.tar.gz"
  version "4.4.1p4"
  sha256 "454fdc7127875dd232bf15035514cb5a6043c8d9a2f7fc50320c987ba4581751"
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
    sha256 arm64_tahoe:   "1ea5c3ea1322754fb1563c9771b06c7182088d3cf5f77160b55667b938a6c230"
    sha256 arm64_sequoia: "ab03c95a4382e6272e36d34b9201d4751ae8b9c3cf72349c8fb353f5263bcd8e"
    sha256 arm64_sonoma:  "0a9153280622fbd5dcbb74a40babf4cad7383b855e0daab2b6e7a1ea8e14ad19"
    sha256 sonoma:        "e585729380839d4f3c98eec1c46468fcf9dd8c7f9b8b15b2756c828ff372f5da"
    sha256 arm64_linux:   "403f5a5dd0ea54bfc9fade96e54bde736d8a211ed08f91a02f07f2cdcaf1d86b"
    sha256 x86_64_linux:  "f8db62e90737ed46d5bea993de729dc2371ec618621a427b632fa7c91b93ebe7"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.13"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-python=#{which("python3.13")}",
                          "CXXFLAGS=-std=c++11",
                          *std_configure_args
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