class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.13.1.tar.gz"
  sha256 "e51da39454e96f77e3c244e8b8e065e3e9bece7da8bf280b736545be66adbe01"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7d55fb33d86013f4dbc37d6e2b4888b459a3f867ef44d0e166d0cdd18338623"
    sha256 cellar: :any,                 arm64_ventura:  "c3d2280919ca5efe953c7427087e57a4f314e731e95e821002d54e7f1d721963"
    sha256 cellar: :any,                 arm64_monterey: "ff965184d28d0e221bb243dcf5ef633c66f2e149c90eaee3351492e8b16ba4da"
    sha256 cellar: :any,                 sonoma:         "ed91cbb4f3bc506db775a176645f40f095d12a5889f72776f40352f9f15f1388"
    sha256 cellar: :any,                 ventura:        "a213757991438b4fa7035710bdc8f0b3d96a4ad317c5315cba11295b6fec93d7"
    sha256 cellar: :any,                 monterey:       "889fc2886516aaed8bd3e67626697b129afeda40d372028cc5affc2f5478c376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78fc0dd3a82b249d2c0fef1385ec36e5ee6ba2eb82005d6d389d4ab05df39ffc"
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
      url "https:raw.githubusercontent.comaous72jp2k_test_codestreamsca2d370openjphreferencesMalamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_predicate testpath"homebrew.ppm", :exist?
  end
end