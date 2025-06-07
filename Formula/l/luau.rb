class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.677.tar.gz"
  sha256 "32d8314cdbbc7e4a04d1a83d772d3259b4228f047e44f23bb106a0d1a56679a7"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe47bad7a61921dd54286326dfba85cd92eb714720ab361614587acdc9084658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8ee8f0151eb3712aa4638e99b9ce2f758fe20ad8c604db7f7d2133995db1d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb5d9e52ff43a9bfcbc92947b418b35ecb026d6e07a65ce3cf5dd7857ae3a970"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a047ea04dc1eda599eab05ac2870416eb68de9df349696df7e1b6dcc908b055"
    sha256 cellar: :any_skip_relocation, ventura:       "21fb33089861a33d75708c28d8b57de5b6068bc6a32b84a6b9ed26a73e4889e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69bdd1c24aa2e781cd80e1fc7778813e9bbe816636aef09d1c9405b62902be0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ab797af37ac09ad6c80340ba7b6a45bc87f9a36e6136c8031aa8755e722516"
  end

  depends_on "cmake" => :build

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