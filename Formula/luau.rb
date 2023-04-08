class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.571.tar.gz"
  sha256 "3ab30e6d5e2f31024b99b48612b1833cfe8952e82902d8c1f3c1fc3e07c1ab70"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "306e1960835631de383ecbb042c6d0ec2b120cb1a7eb905562f59d902c137d18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60591b4935ebf12ab99d8282d6ca48d80d52fcd5e51918e5d2b9549283f8c92b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ab6b7fbed3587861942fc56abddd18cd3cc50136c3487e16eaab14d5ac34e7"
    sha256 cellar: :any_skip_relocation, ventura:        "776b28f025df5d0f8d3ba2c1e9f823699002278e39711545876e964ad9dae837"
    sha256 cellar: :any_skip_relocation, monterey:       "4a203876fafe61fca750519c38c9a9f7bc6a7c4e13555314651f3fdf8184eac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d20ad57021a40a1233c9904018f770cc6b089720524cd8c24b899e625a2f6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284bbb7c0d67eaffb30af01ecf8c61d27871215431f6448bf63314ee11059537"
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