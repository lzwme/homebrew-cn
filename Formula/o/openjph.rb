class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.5.tar.gz"
  sha256 "46e33b5c61798bc0fb5aef19bcdd2aa8d207cecc0d389293ee3cf0524165c648"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a52b1e186b1aeb5a7bdfd205a94f623f31c6b56c00bbc29e956a46518e949da"
    sha256 cellar: :any,                 arm64_sequoia: "8a985ce7b1bdbf4d15d6e3f7ab90f284891a1f132fc825e1579e5867b12d5e22"
    sha256 cellar: :any,                 arm64_sonoma:  "ca31bbff611c4ed56488addb9a93a773287cda534914a89f27301258901b5a53"
    sha256 cellar: :any,                 sonoma:        "820e6178a1024f7f1e59a16bf9fb56e479d9030bc9aef1b70eb0ed09563606d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836201fe90cff2727dfe9693e03b623df427f89885f3a49c77785860047aac47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cfa230e62507c9851b9b5ea00799e54be50589c8e35d6c5a4e1aea8c59ea956"
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