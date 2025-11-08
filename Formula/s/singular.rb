class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p4.tar.gz"
  version "4.4.1p4"
  sha256 "454fdc7127875dd232bf15035514cb5a6043c8d9a2f7fc50320c987ba4581751"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 arm64_tahoe:   "d2d99b6f714212d10bd448dbda257ba6557303e04b7b2fc89c0aa9e8c6a7fd40"
    sha256 arm64_sequoia: "64e89e241e8539049e82d9b51aa4e3f08e6f7872582e79798cb92b2612c1b781"
    sha256 arm64_sonoma:  "ece80e6178b20cd6aadeb84b5c8204f902fce245d324bdb54885b9d09f674382"
    sha256 sonoma:        "c297e8455d3c510f20e0e133ae177f7c2adae9472b5e7d8671f7616a6a98de99"
    sha256 arm64_linux:   "ef783fbba6f70a08e8a8a593052d79fd209bcb7e5279f92734eac5143be1961a"
    sha256 x86_64_linux:  "c11baa5d0d1126ae09128c338f1dccc63f874352f8010cfb8709cdeb2e6e225e"
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
  depends_on "python@3.14"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-python=#{which("python3.14")}",
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