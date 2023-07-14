class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p3.tar.gz"
  version "4.3.2p3"
  sha256 "9f7cfc838eb16c976369e498845f69551a95c4bc9d6d6cfbb4657836aae5ff3e"
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
    sha256 arm64_ventura:  "9eee9e14b5f9bc8312c14e2c99b6bf453f7edb68e72ff6feee1aa606c55fac56"
    sha256 arm64_monterey: "1fc511fa43afb50465719a19da2194e00a37786fb87cb489ffb396edbbdefd73"
    sha256 arm64_big_sur:  "c8defb98c5d2988410bb6393f1d0f98b228466e70d8292df99cd2c949c10323a"
    sha256 ventura:        "f58904d3fdc4ee84091c797b108dfe62f668d090c768844c9e8730922c555075"
    sha256 monterey:       "0b364dfe62c5fe22b4bb74ad70308fbd2776d5e2cf390095794fcf41474bd73f"
    sha256 big_sur:        "fd2e393dd3381e0aab3222a67f3df3c6ad4bcb0e3295de7ee79bd27ef6a4f6f3"
    sha256 x86_64_linux:   "960b0d58537cdfc6c8a2b0edfb75e13b2fce62414d273df9b15730a0aa395451"
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