class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https:github.comzchunkzchunk"
  url "https:github.comzchunkzchunkarchiverefstags1.5.0.tar.gz"
  sha256 "0a1568482357f0c5d08175177c282c1deb318a74b83120bb013909819676f23d"
  license "BSD-2-Clause"
  head "https:github.comzchunkzchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "eb8e4cf033d7be5907754b0c266e26929ea615d44cb25d09f967ec7379d5de79"
    sha256 cellar: :any, arm64_ventura:  "d93bc9133063264b171b2ba069ae2df2cf888219348fbe32c6ebc94552943b8d"
    sha256 cellar: :any, arm64_monterey: "a470dcf3d2a3fcff90876aced68e5004f43163e14c50a642ecfe85c4ad5e1880"
    sha256 cellar: :any, sonoma:         "81563c63d0d30eaeb38e8759b83982115c023c9f343ce877a56ce97176255a70"
    sha256 cellar: :any, ventura:        "02d21685b0cb76578c1c9761f35c60cb07077dfe81936745bf26ea41fba59ddc"
    sha256 cellar: :any, monterey:       "c0e522a6b820794e0b47cb0f235c6b1466cc4359ea23b7fbaeeec6818459cbd5"
    sha256               x86_64_linux:   "03a505230503d892c1604170bd662181510b77129bb0c37d3003f17ada80e187"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin"zck", test_fixtures("test.png")
    system bin"unzck", testpath"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath"test.png").read
  end
end