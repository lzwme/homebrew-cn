class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.21.4.tar.gz"
  sha256 "92a740d5ee83adb4b35fe6c916910e7d6613b71fe21d11f95b955ad615bed274"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d92f3eca70b821b7d3a2c18beff0ade2bb8a8c4ab81ee110e912fd307c28406"
    sha256 cellar: :any,                 arm64_sonoma:  "bd75cefe2f94315e2365fadb180124caa56dfa9730895fd771dde360b840df3d"
    sha256 cellar: :any,                 arm64_ventura: "86e44e3631f65969f3d823ed1d84a6653de879e646b27eab33c15e28fc5b08a9"
    sha256 cellar: :any,                 sonoma:        "e7a54a5d594a5b88a2f5e73ffe7709ae12c94a36dc848fb2949f781e3db12e94"
    sha256 cellar: :any,                 ventura:       "1e2574b739d70e7840c1402e55c0f03c4ab6eb770448df257bace0154b7829e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32588ac99e1fe95d7b199510b13e170fbce4f51703f4a15d024a555e7f9bbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5f49875a8d4580c40f883fa0312f72b40d565b95ff25c35a20c51fa432561e"
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