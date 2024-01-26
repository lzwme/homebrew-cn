class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.10.3.tar.gz"
  sha256 "9333fe0d07b19e9cee45708beb6a965d3d4aa31b19c5e0de54c9d46618bb4835"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0660bc2dc2bb1570b60b47bb9fa1431df176ea256797d75851d2a20143df5c79"
    sha256 cellar: :any,                 arm64_ventura:  "b52096283d579b14e6d08f821414ab6a900db85240ed73a1cb7c96bff4cb7fae"
    sha256 cellar: :any,                 arm64_monterey: "d21589a3de4618a57406f70f1dd95e98373b6f0b5cea4b746f2a82517d95eefb"
    sha256 cellar: :any,                 sonoma:         "20c6e2e7ccdcbfb718fbfe7526b1d6968db481ae4c36da9f33918043ae35623c"
    sha256 cellar: :any,                 ventura:        "054993c2d865bdbd28ff233d39206a18e025f8666e1cbfb31ae9ac65570a9ab6"
    sha256 cellar: :any,                 monterey:       "1b257f76dce7b37cd4c8d086eced54800fae2af91e2d9e40e021dc16e8e28592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dfb671b7eae9ad0f9de66d7d0a4698b8c232641bac699b27d563884f970f1ce"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
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