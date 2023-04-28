class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.04/MediaInfo_CLI_23.04_GNU_FromSource.tar.bz2"
  sha256 "bc7da8717ff74d89d1d69d886af812f5c47b1e502c1a4e05360e41c47450ff30"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3cda0010ca68f8ee4e5e7e671897027ecb8118c8362f25d5bd5e3ef2dd5e4135"
    sha256 cellar: :any,                 arm64_monterey: "ea8bb90ba43169f0cd833a64a8f8a645a08377dc55b942a37412379a1c739806"
    sha256 cellar: :any,                 arm64_big_sur:  "6c4a763a1e646998fa0e70a284d2013ac81f496ff7ae4265075385aa1a4c5a78"
    sha256 cellar: :any,                 ventura:        "1512a405e65e09586056aa13736a3ec96fdc5837e23455cde23a735ec8180dae"
    sha256 cellar: :any,                 monterey:       "9a3fd29a9e87f89de0ad9715d84a098518427266ba9362978de3f20d8b871438"
    sha256 cellar: :any,                 big_sur:        "4a8a02a4a5b915232da4d21436048fcee7ff1bce62e66a4c00528be79f719e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d894f130fbf00c6c6f6526c5d7c46593a3ce19f2d3dc2e70a4bad1388917997f"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end