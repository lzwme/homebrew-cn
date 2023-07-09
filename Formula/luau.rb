class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.583.tar.gz"
  sha256 "67ea532d560a2bb05bc2013823c6f732e0897ad1f4ddf264afb1c784b417cb07"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caaa5e21bdcee5cc2c175c08a49e203cb2fd3a019bc6d1eafa8302bf549c394f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a116af67d985f6e71610373cdfe999dce421af032f0e2a47ef524bab06b5108d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3355d6d8d60b0b1af3ab16a0517184ee294299a35ff3d327caaa4c72fadc903"
    sha256 cellar: :any_skip_relocation, ventura:        "915593ba595609ff38f80dddde6b10cffa1494ad1e4dcdc2af1ec640b4bffbd5"
    sha256 cellar: :any_skip_relocation, monterey:       "1d7a63460e9c6c7dd5c5738c0600b1f93d188dba1d9fbfda40c09177d7f7497a"
    sha256 cellar: :any_skip_relocation, big_sur:        "65951b179bcef9e8cfe1fcf2986c2747cf186ba2a41d628819739697257c427c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4204300b915fdcea8b85d11a1752921763a9495ac5ecd220bbbea0867eff3ad"
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