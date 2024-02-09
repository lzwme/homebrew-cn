class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.10.4.tar.gz"
  sha256 "0f89f9b15c74281ba516f643527d19f3864c95b6646c158d16d4c73fe9eb5255"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b6b268d3f97f3f77c8af8e7cc4f2358b75a491d56fd27447a7b33cbef72f7d5"
    sha256 cellar: :any,                 arm64_ventura:  "4d9f2781c69a83050a15c99544cad393bf350155d459446c5752a951419d6435"
    sha256 cellar: :any,                 arm64_monterey: "22db6854ec544a73911e3e3ede5134ddaec4d4306ce70e1a5b0185526ded6bab"
    sha256 cellar: :any,                 sonoma:         "d75129d0651087ee744a4853ea7ed05438ea490c0161f08cdf14c9aa118cb7f5"
    sha256 cellar: :any,                 ventura:        "f45fd831de50fea998813c66f421e63926b9f435ea9331403ea8cc2c20e142b5"
    sha256 cellar: :any,                 monterey:       "f87f1185a068ce086625418ac8eb644c3272822991168a7b0fa5fb91e54e00b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc8f58c7ed676fe66be990366641a166b49833b8619c4676f8ed7a3dcc4cf54"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DOJPH_DISABLE_INTEL_SIMD=ON" if Hardware::CPU.arm?

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