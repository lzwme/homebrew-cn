class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.2.tar.gz"
  sha256 "c99218752b15b5b2afca3b0e4d4f0ddf1ac19f94dbcbe11874fe492d44ed3e2d"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba5c2d1c1fdcf3b76c0aa99f14111403dffc71db90561cdb4d7769dd7b2b037f"
    sha256 cellar: :any,                 arm64_sequoia: "badccdb9a77d938b670b6fd60817549fe1cb94c5ea9a53768e20c37f50a14ccd"
    sha256 cellar: :any,                 arm64_sonoma:  "9490d8d3504d493d2375eec4f52570ca21f5def6a19b775be1698dd6c52547fe"
    sha256 cellar: :any,                 sonoma:        "2fef1e922ff9747cd606ffec418b234cb850a6b4e45fd969c8cd14c57aa7288a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cfb1cabd8d4b4ae4442acef568666cd5eeea1ccc21c0121e428e195990e311a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e264ff58c095a4b5d93dbb080834f10a9f8c3a943bb787124fb938119cc8f0a"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://ghfast.top/https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end