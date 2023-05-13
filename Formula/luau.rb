class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.576.tar.gz"
  sha256 "c22175202e40ea4380c59b84c80fde0d3143fcf20fdb23f09441fcf77990cb6f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc59f12af188a48b76889bb0ed87af5ed2ebf7a702b45908e024cf0235c576c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4feede60db4493fb1f5a59c9d5d544944be6ec1b6c3a3cc549414f68905495"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f233fafff73f180c7920e895f84a74ca31e86cf20c48dd0e812c9ad8f40890"
    sha256 cellar: :any_skip_relocation, ventura:        "29a77bf984d6700108984160ce691a4bd6e07143f9565bef3480b185df3ce977"
    sha256 cellar: :any_skip_relocation, monterey:       "f213aa9e5020b8535fef90928764a2216b5b93a0bae686df0996a1ed3fb6f67d"
    sha256 cellar: :any_skip_relocation, big_sur:        "98cba6270d02b8b0291b9989c0f20bb330a6aac8dda7b5bca9c60dfd253e1227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34a793fecc9ca288b9e727ed646f58a9d49a2572a0e7828c11c5159abd9faf5"
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