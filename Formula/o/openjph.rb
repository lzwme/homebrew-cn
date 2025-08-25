class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.22.0.tar.gz"
  sha256 "c9c6e9ec82ee8770ede41eeffe8acaab1814724c698b258c3de160dc09cb7d12"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0358455e3ab0d3fdfb4ce3ff8ba4d0166c2c483ba07eb7b5295867e53062eddc"
    sha256 cellar: :any,                 arm64_sonoma:  "27dbb948cce7c5b128edeb7c157832e94125cd09c46aebb186bf6396ef0b843d"
    sha256 cellar: :any,                 arm64_ventura: "292ece4f0ce46c877f910abf94b2404bbaaa6ee3d71ad8cb330462274c6bc7cd"
    sha256 cellar: :any,                 sonoma:        "d79ffe93ebf42a5141781efb38c943c321fa5fb2e78cbaf243cf44d63b90781c"
    sha256 cellar: :any,                 ventura:       "ed5823f4049435d5e3aeaf8a392a8d3e10e53583f153e158f1a6e0f45c34e561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868c8394294462480491487cff83eceb3312d2d5f41d8b2bc45077c9751b8384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e62a6fd0ba7eb90a0cd5a9a0e00a834a8ec355172a723921fd1824341f86ccb"
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