class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https:www.singular.uni-kl.de"
  url "https:www.singular.uni-kl.deftppubMathSingularSOURCES4-4-0singular-4.4.0p5.tar.gz"
  version "4.4.0p5"
  sha256 "f240c210d2f5a7ba30a35f43ffb3c926decb103f3b9ff4a35ad4baee093a41df"
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
    sha256 arm64_sonoma:   "213c26d2539833cec4b70570e7bc35b5c7f18b478030fd2c645a120f31f9900d"
    sha256 arm64_ventura:  "1899af2cbde7043f6bc04832a856bb93a3845cd308f03c7d122d12f8e82cdce3"
    sha256 arm64_monterey: "064ea698eeeb50c06ccea50856bd0ef4fba7ca3981024b5dfed6265fdcdc7020"
    sha256 sonoma:         "6e83032edb0986907ac2958c14f5bf33d6a0e8d29a8628756949b291a314cd0c"
    sha256 ventura:        "6ca2b2b9fa561c9ba85d99983cab8b22d7c307296b42eefbe65126bd80e48d0c"
    sha256 monterey:       "ec9cbb4300fd88c4499fd406d389a4107b9a1f46f934078ba8ebedb84021f7e6"
    sha256 x86_64_linux:   "e2ee20821ab2b0b03a8bffefad953f7e45b8cc0a83a098b717dcb1ab599ce5c7"
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
  depends_on "python@3.12"
  depends_on "readline"

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python=#{which("python3.12")}",
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