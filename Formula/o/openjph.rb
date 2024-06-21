class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https:github.comaous72OpenJPH"
  url "https:github.comaous72OpenJPHarchiverefstags0.14.0.tar.gz"
  sha256 "c1e18a5d9632a84294a72e8ac119e40968ea56ea214291d39c143fdffaada489"
  license "BSD-2-Clause"
  head "https:github.comaous72OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0651655b4728e62a28c81840619317818d9532c49f3c1ba051527988565d1ccb"
    sha256 cellar: :any,                 arm64_ventura:  "b11064a8f17d59fcba4dbedf94bc929274851055392e5bd202e1df57cc9f64bb"
    sha256 cellar: :any,                 arm64_monterey: "c4f869661f5796608e05dc29857b602b489b0dbc2f565d138c5cacdbaf26ca52"
    sha256 cellar: :any,                 sonoma:         "98872938312863e8a137dbd7943c15bed73f8cb7f6608d5a43452399359a2db1"
    sha256 cellar: :any,                 ventura:        "b143d58a94d461ce4bc935417cfb72ec184a938927d1a9777b0d304c965fcadb"
    sha256 cellar: :any,                 monterey:       "5c60ec528cda0ad2de5cda943446ed2bafed9c8dd0a0da0a9804e1905de6db93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06413db337172075cacdfa3aa7da206586da4acedc2c8b4058522203a0e401a"
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