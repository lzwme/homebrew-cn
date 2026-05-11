class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.27.2.tar.gz"
  sha256 "0aee36d16cc7a93aca031bfec7beb7e272c8ea9cfa8773536187f96476d22565"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c30cd1c02de44bf931a13c18dd978586c0a0ed5e0672d9bf2e9de125a2c17b1"
    sha256 cellar: :any,                 arm64_sequoia: "4ce3e8bc06b3250ef1c9d32b5a21475ce44877f7f27d6b5d2a9cf79a33a8121e"
    sha256 cellar: :any,                 arm64_sonoma:  "4d47348e6fdc046e04e34c2d41c38ba4bb39db25edd94f9fc23da2ec639db19e"
    sha256 cellar: :any,                 sonoma:        "cbc215a1a2a49a3fa0926112930e4c131aa13eae0c0684b6ff064487ff36844d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49690ca98f8a41cb431cc5b0340365c945d5b36827087975ba35102f00537b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6527ac2f6bb6d1f9de6d0520c1f403106d8120a7e894175e661d927ea8cc289"
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