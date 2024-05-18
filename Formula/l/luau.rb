class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.626.tar.gz"
  sha256 "4664dd5e68571e9455659ac471f18347d3cd2f07e66e57c4b0a68d0a394de252"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c74516c9e5ffa1664168c47ba6211b45fc660cf4a0f58e3d4345bacd04e2179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5590f8dba0d53a4f4309dceadd8210b7b02f649bfc8f6fa2cb26a77916e1de7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89272477caeaf9d6d529ea23d45120a595b672c12dd0c61aba27a93c0c4e9ded"
    sha256 cellar: :any_skip_relocation, sonoma:         "adcd086085c31c36379eced34708ba35ed0af688910c633f2c9d3e7f2b784c04"
    sha256 cellar: :any_skip_relocation, ventura:        "95f91bbcd2097c23cf695eb666dd2cbca66549c2f915e40bc7a502c99f8c226d"
    sha256 cellar: :any_skip_relocation, monterey:       "00023145bd77a3c8cce75f586868914a1ecc175bfb378a9a9fac774f7e04a609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "711c40234dc2767502ff1310cce447e70bbb902642be966daa29289ccd05a9c4"
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