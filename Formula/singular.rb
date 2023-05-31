class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p1.tar.gz"
  version "4.3.2p1"
  sha256 "87b8fcbcb19a849ab767db999409c03bab7e408e5a00d05e981988fd9ea279db"
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
    sha256 arm64_ventura:  "ee7c42d28d45cb03aa21ab05915a5acde8e9360ccb6deaaa012d17cba0ea7608"
    sha256 arm64_monterey: "23c97de4bbd28a6c860240191a0145e61c8bde962e99d6f63dcec7525761e757"
    sha256 arm64_big_sur:  "2f80a5b9b15505985d2c15597f807c47a5f88fb48dc04cf95f051484801a6f61"
    sha256 ventura:        "2bdb074abda45b9e9f88699bd3873b35952895941c53cc2194b0ae93cd3809b7"
    sha256 monterey:       "0c433d10f7d014328eb486e3a7de34c9be6dcaffe5c995b6d4c8ac5c75ad2b5a"
    sha256 big_sur:        "007f9ba100a30d612f3ad279a76712f182516d95fa7f10ab87dac7633bcc46ca"
    sha256 x86_64_linux:   "f138c779952f1f7c210506fdbb13653b816e6fc8a075385b7af7aef5f5f6608c"
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