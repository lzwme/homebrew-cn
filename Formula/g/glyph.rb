class Glyph < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/glyph"
  url "https://ghfast.top/https://github.com/seatedro/glyph/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7de7936a13b92b18240134bef64c006ab73988850a8776a1b276e22b73377f15"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65fd307f046f5a02aac7c6b501e5fe18e5428effe18348d0f325434d88345dbd"
    sha256 cellar: :any,                 arm64_sonoma:  "464f70d7d55c68ef851b98495678a655d8bd9da9091b7d2dc8f6e3c1b1f6f039"
    sha256 cellar: :any,                 arm64_ventura: "698a50227be0700a78a83e9465c918512c6ff85249695bc1659daecf12fd34e9"
    sha256 cellar: :any,                 sonoma:        "5b9a6ac30820f3da6ea3a6db4a5b5c2f256f28ff60cabce3aafd75f4fd116d89"
    sha256 cellar: :any,                 ventura:       "6ca22ad633b8aacb5c48262d620ea2b9cc06bd3b583e42e477745eb1e6ed745e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9d554f601c7f51ac4e716ca96e5a4bd0a4ac28e44b427604a9247b8a395885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c997639992b3d57e15aba0c84174ca4fae48aab25916ac90074d63e2a50aee"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-02-19", because: "does not build with Zig >= 0.15"

  depends_on "pkgconf" => :build
  depends_on "zig@0.14" => :build # https://github.com/seatedro/glyph/issues/32
  depends_on "ffmpeg@7"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    system bin/"glyph", "-i", test_fixtures("test.png"), "-o", "png.txt"
    assert_path_exists "png.txt"

    system bin/"glyph", "-i", test_fixtures("test.jpg"), "-o", "jpg.txt"
    assert_path_exists "jpg.txt"
  end
end