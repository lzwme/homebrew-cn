class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.640.tar.gz"
  sha256 "63ada3e4c8c17e5aff8964b16951bfd1b567329dd81c11ae1144b6e95f354762"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19867253a0ac0c90f199e6c80a91ca0cf4e73eec03d03b95b20b1479e96c3b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e87ce2acab4a7432fe6aefa939ddb640025e3925b7dfdca0233edb0e8006fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6321aba2abfa13a58c92cc7fdcc7eef755c4ee6cdf2d23c60b0857ec298852dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "453018316670fb816468f1131d2303ef3af8e26e041e57ce8a060a42f57a495b"
    sha256 cellar: :any_skip_relocation, ventura:        "2517a0e2ec3bcd94d3ca055466e44c2a9603faeb6c6eb37a94dca27ea8f1a268"
    sha256 cellar: :any_skip_relocation, monterey:       "0aab60a756d0ad03e6b64428674f3a7639a2a11d12ae934e93d8b3e34be374ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46b5aa3df3007f3af9c33530863cccdc44790b3be50dfe914a0b81bfd7d7fc39"
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