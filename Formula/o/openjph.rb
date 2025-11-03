class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.25.0.tar.gz"
  sha256 "376fe46b8234e48eff0d26ce0bb9d0ee73aab5714a8b72a31d73d166b75aa62a"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "553c878d754d6c03a1a0110657d98062a13ff44d326cbc96f0201d16820785d1"
    sha256 cellar: :any,                 arm64_sequoia: "6e31572a70adef98dcb35756af04e63b9427c7327e030b95ed25d74f72523d46"
    sha256 cellar: :any,                 arm64_sonoma:  "84c401ebd40403443c490be3cf29bf8a017ec8fde6048cb088ac735261550d2e"
    sha256 cellar: :any,                 sonoma:        "9c26fe1966ecf55e22e71c159d9c9a808a77c8ab1e10afb0bd8bb2eee606a650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84678afac0aca54d287686c5266f1cfd4ec47401572feb6dd73bd6ce1747ce58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640c6991922625d92baaca3beec0813cf305d0ad55e7d5aff516302e2a21ba69"
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