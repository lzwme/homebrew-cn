class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.16.0.tar.gz"
  sha256 "94bea4d7057f7a5dcb3f8eee3f854955ce153d98dad99602dd0ba50a560d7cf6"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "097e11d077f289f14ca5efaa0aa72333ee661ed0f192e9a9e6619a8cefda63e4"
    sha256 cellar: :any,                 arm64_ventura:  "80eb2b437e53ad0b2671c5cd4be46bba92a0b4cbdd9ccb095c5c29ef3a0bae94"
    sha256 cellar: :any,                 arm64_monterey: "7be65919294cda460d103fbd792eacdb854ef5404b3dc641471e24bef73d1e72"
    sha256 cellar: :any,                 sonoma:         "bbf6627fb755a937c2fc89686614b7707cb54d8930d2c153d1e022a4829e7c6b"
    sha256 cellar: :any,                 ventura:        "58b633ab4c25a693aa3f48f717641156ee5ba07c5187866d37fe680b2e524e95"
    sha256 cellar: :any,                 monterey:       "4d2093f69052db31f95c48c3fbefb382ce65666d481def28ee133a0bb1596d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cae0a18f415c415a3cc7c97c13461263d2392b1e1506239b2fa0ddd588e0883"
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