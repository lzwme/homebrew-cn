class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.4/mpg123-1.32.4.tar.bz2"
  sha256 "5a99664338fb2f751b662f40ee25804d0c9db6b575dcb5ce741c6dc64224a08a"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "83a4a74bafbcafd98194c3a8ff082f8bbf84cee437cb94415d2b5a4939b1e0c2"
    sha256 arm64_ventura:  "18b753aee482064a32ee44afa93a2357a01e6885c62f48768d7c0b0a20bf5400"
    sha256 arm64_monterey: "9cfcc26737a2402242c00c2883120f4a59e834624f109fc176bb2aa677a0c4af"
    sha256 sonoma:         "37930347f77ab308bce0928294c1cc8f06c4cdccf8191b9e8590c07ea519c272"
    sha256 ventura:        "91aac3ae9782e7637371e427c5339892e8b557992885133d336c27eec758f006"
    sha256 monterey:       "5b61078163f6fe41de47e89fef05288640cb0323c0ea82ffb68fd52f1ab93328"
    sha256 x86_64_linux:   "b5f84640d70da48e419031fdc9cd760c97e51cf73e536751ce56a17e70176c1e"
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