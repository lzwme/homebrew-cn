class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.21.1.tar.gz"
  sha256 "36790c75b9425df40fb5a8a272cfbb91f38972648da7e3ce515077f622060e12"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b0f1bcec886823a051dd4cad7767d33b5b1ce741e390f705d84e23f8b1b0da6"
    sha256 cellar: :any,                 arm64_sonoma:  "eca553179bd3b5548ff82d3cacda78ffd983ace59876c37bb6344e26ceaa2868"
    sha256 cellar: :any,                 arm64_ventura: "a4972bd261e4d8f4436de225877811fd13032a0935a0d2564ed6b5d5d2317295"
    sha256 cellar: :any,                 sonoma:        "f6a0278df4731fde06a3551a35626b6295869c3643f556f885135b4d7aebf544"
    sha256 cellar: :any,                 ventura:       "752f352db258167040b1cfdb2394dee3aa735b357076f5f9f2628a974f7cb595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c301fda41496af29eec2fac30c89fd0cbf13573453ff9129135e5e50430781d"
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
    assert_path_exists testpath"homebrew.ppm"
  end
end