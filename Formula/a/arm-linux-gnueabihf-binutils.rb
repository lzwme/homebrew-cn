class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:  "9a22640bd58aeb9f956952ce2acfe6b1c5839e65ad2435f5ad50b2cb9028af5d"
    sha256 arm64_ventura: "df7dc0a5ed5fe4926d127299c3a60e6a69ee5f2ab44dde0d45a4405db77cf450"
    sha256 sonoma:        "0c91a88f650380dc233502e87909c8c91098b7d2c54ab3fc91509222e0c6d2c3"
    sha256 ventura:       "23bb23a2f2b2a124c43103409fb942471a5db2a4039e53205589bb9c2a585bb6"
    sha256 x86_64_linux:  "8f3092db82c093c9e4a1fe9a41f16aaa041c2edff948b8867e58ba3902f5d121"
  end

  depends_on "pkg-config" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "arm-linux-gnueabihf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end