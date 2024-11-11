class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.18.0.tar.gz"
  sha256 "2484908bf5a171cda957643d9bc85c39d58ef939016e2d1a00122b1cefbbd4f8"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "760908443bbbe4f081d5eac74aea617373f12c9a6dd74ccd6da794bb0bfc0d3e"
    sha256 cellar: :any,                 arm64_sonoma:  "35b2ecff2d5534d42aa30f0c992024c8fb88561f8a64461f680bae276b750b10"
    sha256 cellar: :any,                 arm64_ventura: "e43cd0c2af85aaf4379e1fbcac5667dff97c448af7619e86e940fab0e1ad57aa"
    sha256 cellar: :any,                 sonoma:        "95dbbd2667c1cf12414ca0a765c6baca4ba9b8cc006e22709fef5155b5e8e44c"
    sha256 cellar: :any,                 ventura:       "2cda884caa9e7205de3f459952d829c27c3a941a64774508775965fabf30c7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ccb44a5fdd34dc1dec2882c71187293ed4df6615b9f52586738cbc32ec2295"
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