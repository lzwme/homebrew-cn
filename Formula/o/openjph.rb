class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.28.1.tar.gz"
  sha256 "89629a3c0f61d474073076bb6195e9bb1d63fafb2e1c57ab46aee53a62f21819"
  license "BSD-2-Clause"
  compatibility_version 3
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc664bf495f36c8252959ddefc3debe79069e649ddeaedae39d8f7a8f8f29896"
    sha256 cellar: :any, arm64_sequoia: "dd9f715b6adf4bb6f103f28f383de6b17bef8576c22dbbab837f402e8f36ff38"
    sha256 cellar: :any, arm64_sonoma:  "875c8f6bb2d7bc17783028cd338b990f30536c0972b406e496a69d97a7792c4c"
    sha256 cellar: :any, sonoma:        "93ad7ad5c903e2d84811be18ebdeb3b4c1192e4840982f6b0fa1e68b03024b8e"
    sha256 cellar: :any, arm64_linux:   "51006ce17f160d3571f334e9d50cef7cc2cbcf9e091a9b9a2b54b811aa2964da"
    sha256 cellar: :any, x86_64_linux:  "5d836a02df1f6cc49a7e5efdd130e51e0b8de5c77b7a4c0c5b3c30b666c9f13a"
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