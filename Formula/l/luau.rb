class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.635.tar.gz"
  sha256 "b2ec66070bb53ab9c26e41608dd75c9672c942cf0738c4b965c5eb956a954910"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc078b28179255490e110a55f712e2cb4c8827744d3289fc96609f3fcec651e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "919254f475a1f6a0761dfcdba195e81df35bbef7d82920500b89022109271a75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1358cdc5947ad974a84d780c8d3d8ac9f03f2162555365995378dad39ed26a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ba3f64cf7ac380a5c5626d42723ac9e7fc0e8b624e68f532e9702e535408c07"
    sha256 cellar: :any_skip_relocation, ventura:        "8ffae8c02652ab865010a74d792945fa1d3f04c755c6e2c5c598741892c05be4"
    sha256 cellar: :any_skip_relocation, monterey:       "3c272dd06bbdf3cd32d423d443e2b955d9921e6b3cf6922049e381d696c25786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bfd1f3b4a76ba84d30f1427d7d11cd32edcba7b7956423d5c910886bdf26180"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end