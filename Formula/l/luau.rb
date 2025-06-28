class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.680.tar.gz"
  sha256 "f640c05950e62afc78ea2e83635e127c4a0b0c5e01b9320affd93a38f6aaba56"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a548372e1c27c4606324aa634f8e974d79530ead8b3f7caca45274c579e6d4b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38cc1bb69d52f5590d8de5a8323001c45ed074c184300c1985b5ebed76902ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d65bfa4ea0b6d86b30277ec71f346349fc79da2d49aa7a5ef34565b884202cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9dd2a37243bb99e5b7459258ed43d5eac02947c11375351bb8757110372217a"
    sha256 cellar: :any_skip_relocation, ventura:       "9101266edaa82a3868ec05f33cf0473a2ab06b968ed9f7f53f2ac9ac465e0767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98bb7d92cb516e53f322d37a23d6faf27fe5ec69c70f15434adf0e2ab5e9f678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff907dc2b92c863e68a6a8d121d997e0c3bf17f8b5260b0881e286a0abb1db1"
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