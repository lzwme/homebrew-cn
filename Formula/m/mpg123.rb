class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.0/mpg123-1.32.0.tar.bz2"
  sha256 "23d4629e30a59a6b0e05b39283f78b8e261e70e9c2673b3c1179718b393aec01"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5985103db9b6b8b0fb8742a6c6036694ee685d8dd7d55ffe75283cc9275dfc31"
    sha256 arm64_ventura:  "75c31cb53a4d459ffa6669195b66499715960876258fead02b3008ab633998ec"
    sha256 arm64_monterey: "4d95f9f748bc4924f0352f5b3271bd43a4094f31ac4863aab449b29d226ef8bb"
    sha256 arm64_big_sur:  "7f702bbc78b4fa5cea936da495727450db90c1c290bf4b2e27d41952e802158d"
    sha256 sonoma:         "3f5f60550b7f931db3fd29d3928dfbbba291c7df7721e8aa6f3b605252129d7f"
    sha256 ventura:        "9949adf544c414f4c3bb6059d75deb507e7e2759410600aab6ff2c36e48042e8"
    sha256 monterey:       "d9b3a61716f0dcf3e5836910168953a93a2b39c67da0402582ba16fd720ced44"
    sha256 big_sur:        "967d0a0a3cafc99c6176bc6cb447da62e5d60ea55237d525fa4028b822f305c2"
    sha256 x86_64_linux:   "767e4600540461561e997ddef4e49ad254099948dabc7fa0e26f4d0f01e5cc21"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end