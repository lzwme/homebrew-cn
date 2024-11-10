class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.651.tar.gz"
  sha256 "bedc98f8df872041e8ac956bab4269e279140220d69c56032365307c36733580"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95c9788e8d41b69c05c2fbbee3b5330fb279536fc42c6d47aaa8a7d055f0417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb59558e056730c24569f25fbf595442cc772d889fe99bf9d5ce8efcd238b046"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ccdafafa01f9195857976b2b1aacc96fdd0f115dbbe9acc7f29f131aa688ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85cf9eacee3dff00169dd44fdf1350f18a7109b4f5f84b8a687058c087d2165"
    sha256 cellar: :any_skip_relocation, ventura:       "b5c3158a6cf0d7538c0bc86df6ab740e9e31facd1039613656e07121079f5ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83974378a3e4b7e35cabe877d0d3e05529850e594e515a351307ee35f2c46b87"
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