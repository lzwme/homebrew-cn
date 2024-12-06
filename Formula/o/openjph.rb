class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.18.1.tar.gz"
  sha256 "79accd348d2d5a3953b973096ace0861b4d1c1147d9c4598c23857a4deefc0ca"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c46a48115f3df080e3b7f78d950afb06bd5ca57bbb1ab918dde86298ef5a4da5"
    sha256 cellar: :any,                 arm64_sonoma:  "feca15dae107d7b6019cd37c69b0dbc36aee30b31dbfbc282e03f8bd7ace84c5"
    sha256 cellar: :any,                 arm64_ventura: "cdcc613fc6a428dfdc31771afdd0bcedbe0cd52f66e3fc913dd1e55ae8d67467"
    sha256 cellar: :any,                 sonoma:        "b209dd3205ba03c54aab3d7c55d3ebb64a7267912f693b1afcf1f5f0a1d42397"
    sha256 cellar: :any,                 ventura:       "172a929b09b3d4cd9a028e4572819c01f5ca3ad0d42b5fa5e4726c2108b4c17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e9d6d02b6996555a7c4841e15855c977b7362a37c36c35b581ab6083f4d156"
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