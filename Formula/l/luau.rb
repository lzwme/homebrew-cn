class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.702.tar.gz"
  sha256 "c434b5aa10cbabc97c82e0751156fe07de69df22484521d47cf0c3854f52ce73"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c51f56e16df036ce14eb2295153d3c4bb4a6c55f0d6a9cafe75eca74b62769d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7427ccc7f35e163dae6ba683154b1e35ef815a66ff4ec794bb029e2128bfb908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f0ac8be5a9e3e5e9aadd1d4fd31773d64a90d1be5bccd38771a31607d64bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb4949393ea41236246aa1fd974172fe41ebe0f2de97786ec8d661ef8770ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec785b171307253cd9b1116ae2a9b87053927ee2a33aaca06f4687170a92f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "097c983eee45441dffd94a57d468e273f0211174df41348cf30d32713b86bd33"
  end

  depends_on "cmake" => :build

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