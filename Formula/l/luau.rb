class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.595.tar.gz"
  sha256 "f9cae07472f7d6f408240bd3619f21cfc5b75bf5ef9461c5e0687ee2d2c10570"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d8545058872765b5fd049d8e67eacd84851c77b4e72abb63554f3ad6d418afe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc65d20fe8457c8d6f9e6e7e02205436e3a3131ecd9d128126b5c9d74e9c92f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbdd381475736d68a4f55df77562e9a5445e491357a88eab4c14c976f59ff456"
    sha256 cellar: :any_skip_relocation, ventura:        "b472c3458ff5f89d949dc90e193e646802f3ad9e91d221fcdd47a6baa305045d"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5fa71da96bea4984586dddd1c8b536233ec83b6ea6d4256bac28f7fbf09de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "861125104109b40df40d4624a2a57afa3b39a14000cae9693d3210427775d1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "188774afb91294feef9c3906e821ab008aa58735ed80018d66d72031b5dda04f"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end