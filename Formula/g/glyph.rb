class Glyph < Formula
  desc "Converts imagesvideo to ASCII art"
  homepage "https:github.comseatedroglyph"
  url "https:github.comseatedroglypharchiverefstagsv1.0.10.tar.gz"
  sha256 "1cfb17da971cc0daac9d0a7744dd1c05fd3382b2522d64e62cdfb28a8faf5d84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e375e615bd24d1ab0c349fc2d6ef36d6382e22af39021b6049bfbc8529dba28c"
    sha256 cellar: :any,                 arm64_sonoma:  "c99e812fd75226cd9cead1d219fb61f8ea51ad5393b026ebfc2e15ef09b81430"
    sha256 cellar: :any,                 arm64_ventura: "a2841556a54f74d09be1737c7fe60dce6388154cdbdc4c58ff1308a13b984946"
    sha256 cellar: :any,                 sonoma:        "4a79fad7a3b61acbf76dacada0d1c830ff919be231eaa4aa17dda4a9158416d5"
    sha256 cellar: :any,                 ventura:       "098729cdee8a707007d0587338b66f02ec96ef972499b68e5bf314b90b551be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff1d7bf9c3446ccf07d3c36e9b5ae3159b5172e161957f67ec3be7483358d87"
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