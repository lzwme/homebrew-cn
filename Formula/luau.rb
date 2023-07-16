class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.584.tar.gz"
  sha256 "d3090fb495dcb4a4ef392ee834bc9d3452845a93062873b08b2b4ffac43042dc"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e7cff8146c3dc53df11d7d8f48d5758cdb07ce15264f9bfcb73481706e2fe51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0187d651ef85b68da5f59d3ff4cec840f2fdffd34712b1bf7db611d0080c8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e367740a4e7afa2e30d2b8e87dd743b94fd5fcbf02d8cc5e5470f093464bcfb"
    sha256 cellar: :any_skip_relocation, ventura:        "1754a79dfceaabc1c6233a863e4c09b88ed5a289061d6ae63529e42621f7bda6"
    sha256 cellar: :any_skip_relocation, monterey:       "d4bff2486b3062e429a89299979239ad86b4ff4d36eeb64e59dee673e68c9a46"
    sha256 cellar: :any_skip_relocation, big_sur:        "b35e82087f2ded5621d506b3096a09025aa6d49ecb2031794708e3292270dc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9eb3632f5ae94610115d74cbd471a8e29bb9bfe119da6f6423a7c72b91e95fe"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end