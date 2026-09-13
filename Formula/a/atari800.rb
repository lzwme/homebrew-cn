class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://ghfast.top/https://github.com/atari800/atari800/releases/download/ATARI800_7_2_0/atari800-7.2.0-src.tgz"
  sha256 "1931b3178320d92ffd02810aca7e8b7347652d85fd78e430f9f5e39cb938c20a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7c56d32113ca1a169ce5075d66fb991a94ad23a930740c911744108574cfb8d"
    sha256 cellar: :any, arm64_tahoe:       "87f19137d78d179aca6e54c962d50bdf119134e772d06e026a24277f067e2597"
    sha256 cellar: :any, arm64_sequoia:     "4a2c9025cd4a3a5b2df6ff35a8135bdc7bf470bc80687c3260646f9e9b3624fa"
    sha256 cellar: :any, arm64_linux:       "20981f9ab39646a86250aa1829e4ddff0f61acfe005bcf109e24c3de0ad4cae5"
    sha256 cellar: :any, x86_64_linux:      "18f6368144b584fa383d34345835ce194e1f200fc9d9d96618c27aa3bbd87246"
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