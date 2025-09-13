class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.23.0.tar.gz"
  sha256 "483079f402ee6701d5f35a12c96657a715851da770d5d101c3baa239f8dd26d2"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbc10039c76e74c29ed83503c6a8d967a9ecbaf5d297034cf15df7af96f4f846"
    sha256 cellar: :any,                 arm64_sequoia: "fc6fe4d9d833d183099498f2dc5be24779389a6ba790a003d9436577cec0e4cb"
    sha256 cellar: :any,                 arm64_sonoma:  "aaa48db6e84860c04737ee65a58148c42aec0471cf5d125599f460f7c9361eac"
    sha256 cellar: :any,                 arm64_ventura: "ae27a6a036d63a3d7cfdaabdc8b22de5bad557857a2670ef9329b3a855cfdeec"
    sha256 cellar: :any,                 sonoma:        "2b420367ae5252f9fc22eb2bceca7c79441c96f8a7c81093d3e4ed9ffda37667"
    sha256 cellar: :any,                 ventura:       "e4ac838dbb9d89e99ddd80295b35a9fc78a0566dc582156da217754f21c1f11e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7823c53b5331f83879f8bc516a8c08f7621e9949b3dc1658654be86a2d72b3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c402bfec9f0942b7678600396e8555dc59c74fc8d8c13d37852463054930e676"
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