class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https:www.singular.uni-kl.de"
  url "https:www.singular.uni-kl.deftppubMathSingularSOURCES4-4-0singular-4.4.0p7.tar.gz"
  version "4.4.0p7"
  sha256 "6cc1c64490e9c916488cca4bea67701bdf505d71ad8d98d0391af67e03294518"
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
    sha256 arm64_sequoia: "d752785ea5a5ac347d970ae8130eed0732afda4aa0609a83d1475990ea2e1225"
    sha256 arm64_sonoma:  "17305f543acbcc40452772d0cfef9daf60dc6978b9ca68540333c351c6c30645"
    sha256 arm64_ventura: "367b53f9ac95f6bab9abb005502416938fc49f3c1f9fa97f5140a98263235b31"
    sha256 sonoma:        "95945d1700b8569b5ac5b1a9e27e2f9d10c594651480f3b4bdc1e52fece2815a"
    sha256 ventura:       "445df653dbd49b401e6f1528bad8d451549c9b680282ac52355e98e958b0aea4"
    sha256 x86_64_linux:  "b29dafce33a1cce0a663a4cfa333234355aca7fb4f81a3a98f27a7d2159dbbb6"
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