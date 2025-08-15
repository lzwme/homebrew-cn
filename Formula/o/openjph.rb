class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://ghfast.top/https://github.com/aous72/OpenJPH/archive/refs/tags/0.21.5.tar.gz"
  sha256 "5f2fed72b4111e3e74b51e8183ec1be5b1eeac48760dd60fd6a548a0b65aec94"
  license "BSD-2-Clause"
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef394161aaf1467ae7f6f871d6e9dd422e161b5564dac49f47ff0ad2cbfd6a45"
    sha256 cellar: :any,                 arm64_sonoma:  "10648354fc84a25125eba1c03391c57d7a38e00fabca744ee1556c13dfb8a5c6"
    sha256 cellar: :any,                 arm64_ventura: "3dacaa31fa1bb947252ad5a9daa8b4ada52b5a5fade1b36efefa2bd8992482b2"
    sha256 cellar: :any,                 sonoma:        "e239bda4f271d2d69901a8ded821100086653e3ea66905d1554444c9c6613093"
    sha256 cellar: :any,                 ventura:       "627a58be91828f003a1c6b5b45a65bcdb11d7d8e7e03913d412e93050211faa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832531e9f6a5c0336f8100ef1f1ee7ca00e7d626087689eb7ac58b655942e9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bfe3aeb3f2a840098aa984c020e6dd48e05832fbcbecd5b91cbe46c125733d6"
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