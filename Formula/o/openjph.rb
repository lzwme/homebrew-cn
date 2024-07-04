class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.14.1.tar.gz"
  sha256 "a2c9404030a0e50f9a5f5f424f02abccadbd55e32974c16cf555918d5b9bcf20"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69377cced77f54ba015be628835dcbf33750eadcffdbf27a807df23ff95b08f3"
    sha256 cellar: :any,                 arm64_ventura:  "f2c410e5c38c9cd16bd52b76a338f7d6982687f4bc783860cb8d81eddb0ce9bf"
    sha256 cellar: :any,                 arm64_monterey: "477b581736649093f6c37c45b51a8876324f748e9dc2ccdc2a99a7186d3ae154"
    sha256 cellar: :any,                 sonoma:         "4342087c0d1b6e838a4a6f3c5dfceaa6aaefeccc84fe59cd80a6afbc791aa7b5"
    sha256 cellar: :any,                 ventura:        "ad953399ed0a193333fd4a4feca6760e1cf84828cba2b6244b38bba360057e22"
    sha256 cellar: :any,                 monterey:       "b9843cc5086eea02e8ccfc38a63556e287bec6392f8bf5e0b4dd98acd860a407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5923641da3961e7420ae9570702b90bf0837e573e8753a262ada2158c6bac0e"
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