class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.3.tar.gz"
  sha256 "3166bcc5fdec011c7070dbb09e6446656f53c21b9875ad3977f4fe5e280f0db1"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8f7ec7dfa1441a12125fba3ca21289cc220c317c74222fa6266476a9f89b4c5"
    sha256 cellar: :any,                 arm64_sequoia: "ec8e50ab367d82c9b264690983bba9da9dd653dba9caebd3a96692f4b6398ed6"
    sha256 cellar: :any,                 arm64_sonoma:  "833e751fbbfab5a9323b32c22260d128055a6b82b49922b9f07982228527e299"
    sha256 cellar: :any,                 sonoma:        "b007868e4cb3f7b11b7cdbd6dc21d51fec25c05855518c12c0949809037cf849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5cb618adf0b8dd0976209dca8542226ae839c14d4f4c46ea57d2bc8e375287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1788a269ef02ac094411128ed396f5cf27c38daf05fec8df31cfeacc3397559"
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