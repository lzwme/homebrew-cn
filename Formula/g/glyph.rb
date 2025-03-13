class Glyph < Formula
  desc "Converts imagesvideo to ASCII art"
  homepage "https:github.comseatedroglyph"
  url "https:github.comseatedroglypharchiverefstagsv1.0.11.tar.gz"
  sha256 "7de7936a13b92b18240134bef64c006ab73988850a8776a1b276e22b73377f15"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dace7314cab8589f003791387c994758716a5137382f202e20335bf5bcb11625"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d041bb811a2719ca2de1c38d41aac3fd39e4831b4f8544a3b8cc875a90fd06"
    sha256 cellar: :any,                 arm64_ventura: "8816e608f78ee4e9e7142ba908d51fd4672e38575940954b607c6451c9a79a07"
    sha256 cellar: :any,                 sonoma:        "75c836a7c114fb377a59cace95a6d462e73cda26d7cd52bb6f9347ccfbf99015"
    sha256 cellar: :any,                 ventura:       "e29b0dfed93f6057a007755edf3a3c9d22e9734553e7f907554f70d0edbf9cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af846010a44e3d33585ae616c40710644fe6ef842861a9120029a4a970b6a533"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "ffmpeg"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https:github.comHomebrewhomebrew-coreissues92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args, *std_zig_args
  end

  test do
    system bin"glyph", "-i", test_fixtures("test.png"), "-o", "png.txt"
    assert_path_exists "png.txt"

    system bin"glyph", "-i", test_fixtures("test.jpg"), "-o", "jpg.txt"
    assert_path_exists "jpg.txt"
  end
end