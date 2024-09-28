class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.645.tar.gz"
  sha256 "28aaa3e57e7adc44debedc6be9802f2625334eef0124ff722c8ab340dc6bbe1c"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886ebc4b4ae83a53a8c264047c943f37712be438e4351768a22863bcfec159e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c34869952266f24c838ff9d19ea8aac2d33a02bad15793662758dd859854e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bec78fd2dc216a8e59d603eb7a38e52e5559572360d569e808d54a95f16909df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dcb6218a0ddd983fbd36bb3c97f541f4471affebde924b38fb79b7db7a8d1f8"
    sha256 cellar: :any_skip_relocation, ventura:       "b2694fc2aa20b500318d27e32aab32ad658326892af7db5e746e682f27afd84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2c8896c93a171af54da9a164b19cd59eee17534a81650f7f247f82a9ee039c"
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