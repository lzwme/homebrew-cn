class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.632.tar.gz"
  sha256 "61a3f6c02a6fe35b753e4286f922b24c6ce8b6f85aef57bb90b65891d7a8505a"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8548045cc9f935825eece4c54de84a85cec47a60dedf7286744f8b2301fd356c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69d826d704d7d7a3942e38ee635f92dbef14b919891563ad8598825cee678cf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6e8b44d31ff06a295a4f24ef65787ef209b8253559cfedba39d966d9a719b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "adf00dddce9afdd705c2880f97f8a79865608e349ab3b51e574227addb10963c"
    sha256 cellar: :any_skip_relocation, ventura:        "de469056a609a7faa1b2c00e58f200f56b576c868925be156a84456ecc1621d3"
    sha256 cellar: :any_skip_relocation, monterey:       "6657e43eebdabf2a5612173c9d523059f4bd82bdeda312384cef6719e912b1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c078bc6926836058bc0afc3014b6eaf37194cb77f7d13138e89469522e49ff"
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