class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https:www.singular.uni-kl.de"
  url "https:www.singular.uni-kl.deftppubMathSingularSOURCES4-4-0singular-4.4.0p8.tar.gz"
  version "4.4.0p8"
  sha256 "663deb879ba71038879d867b0d559d073d7df12b923d3d1de300d345a390f7ce"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.singular.uni-kl.deftppubMathSingularSOURCES"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)?["' >]}i)
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
        URI.join(@url, "#{newest_version.to_s.tr(".", "-")}").to_s,
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(href=.*?singular[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.ti).flatten

      dir_versions || versions
    end
  end

  bottle do
    sha256 arm64_sequoia: "094396265fed7eda35262a46d402b2829cd60c1912b940f4115929c104df5ff9"
    sha256 arm64_sonoma:  "5043d01bb7318046d2f0d54af57f8ca1bb36b5f2b982484d6cc16e4137c16352"
    sha256 arm64_ventura: "1e29d2f83e1941c6cf270debe24be274548b242407bcfff4d71d6a38bc2587c0"
    sha256 sonoma:        "d4cd39be013622fafa3001089561adb1fb6a2005d90b87555945e713a7fedeed"
    sha256 ventura:       "e12a498cbe96f7f16e07282ed34dfb8014af59e445ddb4127e796e508ad869eb"
    sha256 x86_64_linux:  "21d66825157fe40b36ecf1d067fb7b7359f56123f943101b5145da667c88f5f0"
  end

  head do
    url "https:github.comSingularSingular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.13"
  depends_on "readline"

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python=#{which("python3.13")}",
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
    assert_match "xyz", pipe_output("#{bin}Singular", testinput, 0)
  end
end