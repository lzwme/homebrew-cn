class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://ghfast.top/https://github.com/atari800/atari800/releases/download/ATARI800_6_0_0/atari800-6.0.0-src.tgz"
  sha256 "5b37cb6cd43b8e4163e093276c1ad82293fea6af00a566c2e32eaf0d372c7723"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1739f52db0ab8f644b8619f531284768fae2bfb337946efb1121e1da8590eb94"
    sha256 cellar: :any, arm64_sequoia: "49397d8e76cb4070924851cf77cfba74feab4c45d6e7a631cc89a82637be8ca5"
    sha256 cellar: :any, arm64_sonoma:  "9266ba481bd04178cb920cc37c35cff4cc9887177d9d214794eeb60817f190b8"
    sha256 cellar: :any, sonoma:        "3e4c5930c59e81c1aeaebeae33802d15e569253794a2b2c838fcc4b53d9e15ed"
    sha256 cellar: :any, arm64_linux:   "3c0bd88649e4cb79b169dcb6f7e285c8f46dbedb8b16a719770e764d662ba5b9"
    sha256 cellar: :any, x86_64_linux:  "5246453d991b0bb3754216a5e70084765cc726b0287a1464666d610d497d8549"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest",
                          "--disable-riodevice",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end