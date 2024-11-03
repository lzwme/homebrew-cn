class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.9.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.9/mpg123-1.32.9.tar.bz2"
  sha256 "03b61e4004e960bacf2acdada03ed94d376e6aab27a601447bd4908d8407b291"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "5135c0d548cda34cbda77d37561a8922ca524708dbebde5c810406274c8559fb"
    sha256 arm64_sonoma:  "22762dc6152b7d51ef65ca3b27c02b99d0b823117575625db477365d7c7663c4"
    sha256 arm64_ventura: "888565b4eec8c40e46dcd99771d3ef526d842caabc10e5416381d712535355b5"
    sha256 sonoma:        "a7bc12638c914d5e69fc2bd6ea8d37800436ae6f2f0c1b16387f78b3718da2fd"
    sha256 ventura:       "f70ea7714dfcd65735fb1bf0215f1a692364d4ad76f30f080ea4beb8949027fc"
    sha256 x86_64_linux:  "b36a86bf0efc22e7bff55c0a241014848c7eeda1b343a4479d8cadea62529409"
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