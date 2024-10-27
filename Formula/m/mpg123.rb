class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.8.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.8/mpg123-1.32.8.tar.bz2"
  sha256 "feee1374c79540e0e405df0bc45fde20ad67011425c361a2759e2146894a27a7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4484c0ec123521e84a6b97e7e40ce464bd61942f466a009940344a47c01bfc8c"
    sha256 arm64_sonoma:  "e54cf62c86773502166944079c6ddfc35c3fc357bffc8929888ae7c3af811097"
    sha256 arm64_ventura: "f4f56392968f9fd171062c569a8d18f6d104b90fb87606ed0c256151c296942a"
    sha256 sonoma:        "01d0ae56e52b4b2a74ee1e54c8e9b89f1b79dfad7c16a49ca519761924749e00"
    sha256 ventura:       "06c29196a5a0058886b10871c0c54e7408d68b4818eba312d13aed7bf49934be"
    sha256 x86_64_linux:  "18a79712dc8e4cce5e78c99e565a8ac8cf4b288f850e25e1b4abcab6089ec92d"
  end

  def install
    args = %w[
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end