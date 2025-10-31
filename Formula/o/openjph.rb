class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.24.4.tar.gz"
  sha256 "722f0f3dec81cfc98aecca82baad241da571e6cffe569b031890cfad2ff33bcd"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c996bc85b83c7cb079803a754d784afec0ed8b2210bcf1a7651ea14f8f4ebde"
    sha256 cellar: :any,                 arm64_sequoia: "08608cb29c004c1fdb43739ce6118833fb632372bb68d52d4dd17570fde21ce0"
    sha256 cellar: :any,                 arm64_sonoma:  "62eca098ceb37b7b96c26bc4f28411cd41b465c4d34ea55345517c7bb83086d2"
    sha256 cellar: :any,                 sonoma:        "4f173be40425a6466a5571b59b0fa208a9353a4396904bf6d269e42a4b56ceee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b877644b15151d2a369d92bb2832b42c2d32a609bfc0a61d36cb9bff1c05003d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a33b01fc420638c4582e9c2a32ae6494148886658f2d673e726dd1550690b3"
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