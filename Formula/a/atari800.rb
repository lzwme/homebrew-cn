class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://ghfast.top/https://github.com/atari800/atari800/releases/download/ATARI800_7_1_0/atari800-7.1.0-src.tgz"
  sha256 "4bfd71a91ee06990a6f081dad67193a701c9f3e38f0e4a86b92769b18897514f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b2046bbb99b812cfecc970ec2ddf6654b42e076158add2b97cf9ca7bc5d7ad4d"
    sha256 cellar: :any, arm64_sequoia: "ac043e4ec93a136c50bacf94465f863bb9004ffe85166bc872d23419c7136231"
    sha256 cellar: :any, arm64_sonoma:  "cf85843dd8914203b06debaa713245daaf87ba85ce4d94d9a20deefcd5711c92"
    sha256 cellar: :any, sonoma:        "418c339c15b9bb5a6c32a9bf475a5e17b3fe27854bd9f2980c6caadd62e5dd2f"
    sha256 cellar: :any, arm64_linux:   "db7ac58b6ed7ac8376e582f62bbe525e754a90a1474934f5eb2d2d02faf5470f"
    sha256 cellar: :any, x86_64_linux:  "598d6d219071e0d37e7f43d1bf584f77384cdf55295b1a54f9143b91e1da116d"
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