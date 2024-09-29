class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.04.tar.bz2"
    sha256 "8bff0f18ad81f0e1b99f77ee75a2a7f5bbcb5de2f0ad9fa064ae8202831fb8ef"

    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe/-/archive/v1.0.0/libzakalwe-v1.0.0.tar.bz2"
      sha256 "cb503c557b04f34069654083963a056deb85a6dea25ba4b69aaaa2bbf7290a98"
    end

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools/-/archive/v1.0.1/bencodetools-v1.0.1.tar.bz2"
      sha256 "e41ae682525cf335b5f5ec0ba9b954abfe7b448e8ed13e2aa2a44e49fce2ca12"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ec1014949e006642d06cc86209bcd20d4ca0020deb2bec1e62b577e2f60a3a3c"
    sha256 arm64_sonoma:  "e30210f3367ef1a87ff0f24781352fb4e75217e2614eaccf39bed736dca55789"
    sha256 arm64_ventura: "7f4aaf001b307e40a1c8d9c9244bfefbda96a904b6b34a3b657c0d6666417f7e"
    sha256 sonoma:        "494bd0d2370b36e7d1dd7380762d75960efc4beadd4f24f5ec49ef998ad803c8"
    sha256 ventura:       "f1555c43f27c03d1af5f490689a80ee5aaa1e82d837a942a221b8566b0aa3835"
    sha256 x86_64_linux:  "18a55a968385ac01ae9e61d674001a0785fc7cdb25fc5f14aa72a1fc0a410c03"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "libzakalwe" do
      url "https://gitlab.com/hors/libzakalwe.git", branch: "master"
    end

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libao"

  def install
    lib.mkdir # for libzakalwe

    resource("libzakalwe").stage do
      # Workaround for Xcode 14.3
      if DevelopmentTools.clang_build_version >= 1403
        inreplace "Makefile", "CFLAGS = -W -Wall", "CFLAGS = -Wno-implicit-function-declaration -W -Wall"
      end

      inreplace "Makefile", "-Wl,-soname,$@", "-Wl"
      system "./configure", *std_configure_args
      system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    end

    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--libzakalwe-prefix=#{prefix}",
                          "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output

    assert_match version.to_s, shell_output("#{bin}/uade123 --version")
  end
end