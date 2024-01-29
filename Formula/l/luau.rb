class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.610.tar.gz"
  sha256 "a6ee2cab90c816a86b86113f01d9da865378074ee09dc6122dbe8bfbdf819ede"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21b417f6825f5e8c9fe1383784d385659972ac66411bb26800d8ebc2e96037f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3b53c74bca5c8749b4727b86496da9443534a4a0375eed042a2ff3165dca67c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf4491286b877b75e6bcc94bdfc8b073a2174834f73aa082a042aaf05958cd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2a9e0c135261ec3c58ff1e8602e884c7a5b343b18f1f4b26d4500e7cd886b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "2490fdc24788602ef0c962341dcc653eee2b75f1a048fb77a3d369fb556cf242"
    sha256 cellar: :any_skip_relocation, monterey:       "d627e1ad4400ef15739aab6e97317fa066b8502da9f052b8a1d86b8000334c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a35857ce20100dfb51cbd87fd8e14a5e2c4186068eca02dd603f40eaf6c831"
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