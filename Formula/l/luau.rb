class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.592.tar.gz"
  sha256 "783c8e70dc22a336d26bc69aaaab9a717c895f2db3d3820c0a03f4849a298030"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0ebd293083f2496253e9bf50c2fbaabc15b76e54cb398bbc3e19a76a59c2e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a081f1f5370f070fd3b2a8746889e61cf7122a0b6f198c417be9495ee8cee9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d5989bb57075455263d71199437ed64004fefc984a06b28362cee0d9924c13a"
    sha256 cellar: :any_skip_relocation, ventura:        "74a3191aa110064367d70c8ce70f414330f98e43d4e16f2124115cc5fa0b9c11"
    sha256 cellar: :any_skip_relocation, monterey:       "e94381cb0751471c9a411d0bfa5e5a27dc856f58683674914ef42596b0daa0bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b3163b91e4e9f0ca13a130130898b33069c14986fc01b178a8f7d4eea6aa3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe3dac25eeb05bf873660e607db7c82152f32503aae77477eb18ad9f0a1fc8b0"
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