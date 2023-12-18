class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https:www.singular.uni-kl.de"
  url "https:www.singular.uni-kl.deftppubMathSingularSOURCES4-3-2singular-4.3.2p10.tar.gz"
  version "4.3.2p10"
  sha256 "28c2c9fcfee954e00dfa56eb1a7d418d5b1de67c4398d25a0f2b8f73e71552a8"
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
    sha256 arm64_sonoma:   "5dcd2bcf2277672f6dfe5f3995bb555cba8bc37540c491a705735a369b431d80"
    sha256 arm64_ventura:  "469a76bf8f01ff690fc4290c4b456f407ace84c968a252627edf77c66522c877"
    sha256 arm64_monterey: "ae5e4ecd9378024c216c69e7d3bfbf028ceef4fc8d409bc643db922a448e0e0b"
    sha256 sonoma:         "eb040af9b5e694cf452f0aee16220aff53c1bfa08b5fcc1d37ec1e764b3d49e2"
    sha256 ventura:        "98ee73ec75ae51ca5ce7fad3f0543f76d888fe813a6482405398836257ecd15f"
    sha256 monterey:       "acd3dba476eb547106f2c669c8e9026481669ddc7c62e1f16b79472cdee7c57c"
    sha256 x86_64_linux:   "79590d0fa4ede6f7e78ff879c6a09f26216815c1d5e38f3fe5ed93a352ff2d0f"
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
  depends_on "python@3.11"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system ".autogen.sh" if build.head? || OS.mac?
    system ".configure", "--disable-debug",
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
    assert_match "xyz", pipe_output("#{bin}Singular", testinput, 0)
  end
end