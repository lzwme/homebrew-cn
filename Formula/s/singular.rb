class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https:www.singular.uni-kl.de"
  url "https:www.singular.uni-kl.deftppubMathSingularSOURCES4-4-1singular-4.4.1.tar.gz"
  sha256 "6a4fbaaed05b89c35bff3b1c5e124344a088097f81affe129c9ae619b282b49b"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 arm64_sequoia: "daacbe0d407001d52147723bfaa68feb38f27f0b1c8c86373106143159fd79af"
    sha256 arm64_sonoma:  "c02ff09d8816a0da6554d0fd67cfc6764b1f6cbd6c3dff592b88d21af5e59839"
    sha256 arm64_ventura: "3bebb4411eb54cbab9e97ac5c0b9f871efda6ed37d5ad7374f3906f8b7d530f3"
    sha256 sonoma:        "188921e618c513bbcde4dd6174c81ebcb53f9d5797e4aff95319920bf7a765a7"
    sha256 ventura:       "839afec0544c7d76484106c12afcee8c79a70217acd43e57e466b6c9be750238"
    sha256 arm64_linux:   "2a23bb5ae1c9c0a0280a6fa439b0558d5465d22f6f1a71114b698ed762f2db9d"
    sha256 x86_64_linux:  "06ef152eaa390a447b599cc3f84f3340e9b403a186232afc76214cb8ff4fa9c0"
  end

  head do
    url "https:github.comSingularSingular.git", branch: "spielwiese"

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

  # flint 3.3.0 patch
  patch do
    url "https:github.comSingularSingularcommit05f5116e13c8a4f5f820c78c35944dd6d197d442.patch?full_index=1"
    sha256 "20d4472a394fbb6559fdf07113b6a4693aa225e8ac484df72c3badbcd405c318"
  end

  patch do
    url "https:github.comSingularSingularcommit0e31611aaae70e6f1bc31eac51aa597f564e5bc8.patch?full_index=1"
    sha256 "d34bbc5ac118ccad59a5e956db19ed871425960a987bf90436f627c917f8de7d"
  end

  def install
    system ".autogen.sh" if build.head?
    system ".configure", "--disable-silent-rules",
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
    assert_match "xyz", pipe_output("#{bin}Singular", testinput, 0)
  end
end