class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.1.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.1/mpg123-1.33.1.tar.bz2"
  sha256 "1181f65eb3c8a0a8eed8b595a811988f53c82b0916b58d3c8cc9c3ced66f0312"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "8db0262004266cefbed59a42ed54228756fee5ad06304391735cd8b743d90a04"
    sha256 arm64_sonoma:  "03201050ab6fff407599b2d2f7b39b9cdae48e833cf422398720d92cedee0e09"
    sha256 arm64_ventura: "a5098a1aa4073d8e6ecb0323f81e240d3a10e92c8d7cfa3d24f6761659f37519"
    sha256 sonoma:        "584d097a33d962f5ee9adf71d8d6c1859d20b615b4c2b637a337fecd6a8c4ebc"
    sha256 ventura:       "0272e87963d5b096da721f9211eb211f412a53655c43c3e538ea77e2ef0b3e8a"
    sha256 arm64_linux:   "126b75d33cb834845ab1d70b4e6f00c03abfb1b111b28d5efef0fd6588c89f27"
    sha256 x86_64_linux:  "c924eb0f9a8a228289798dcd840f3b8f48fd734d8349f5bf39fa3609dccca13b"
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