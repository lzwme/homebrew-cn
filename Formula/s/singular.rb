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
    rebuild 1
    sha256 arm64_tahoe:   "bb73332c43aa139f7b1057366896721a848f7b522bd79544d5dcc8c33b63506c"
    sha256 arm64_sequoia: "f4431c9c52707091168df9e0137408844c19ccf4661d9cd81d66820e8f21de8a"
    sha256 arm64_sonoma:  "c084365a9bd822a8be4ec06a552f4539e6dd362962d924858fcd9473101838cd"
    sha256 sonoma:        "ba10b9f762b438a8195cc907fca2168eb24afbfaea4d8e8f3fbb9412a5411b7d"
    sha256 arm64_linux:   "03f0b04cc0b40da6777d065641868386ab0f3144ffd96aeb3b8a5de7dfc26334"
    sha256 x86_64_linux:  "2c1d627c411d376395cfe07c718cb16ca7708909090be8c3219051dfc8e63fd0"
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