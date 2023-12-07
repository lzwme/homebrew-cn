class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/luau-lang/luau/archive/refs/tags/0.605.tar.gz"
  sha256 "fc514e0980293ff73de013af77d10b27f542ab4509e6c5559518b2597d078dc5"
  license "MIT"
  head "https://github.com/luau-lang/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "526ff446feeceab45ed894bb78e69877a5c44d32a8b98fbe502b106bca69a28d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c50967295c2d21c77ef172894176bac6d49c500a64a88e73835f9fabbd989b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf1068bce1d909f4b8b05fac520cf62bd2a0ca0aeb29935bbc84ae7ed9d4e3a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3798c18e61ed3926c4a4c5d5597d6e5f84005f17207690959c3b8ddff209a36a"
    sha256 cellar: :any_skip_relocation, ventura:        "3c1e502a59111420d5cded3b5dd28cb07778e10409fc4b6e2d3bc95a56337562"
    sha256 cellar: :any_skip_relocation, monterey:       "226754fa6b4febf7a632e83208deb2cb4572f6e6fbf903d427bd8ef99f174847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485b856ecf0a3d060d4ebc91d5ecc4ab9fc1f3c358f3c346c6acb737dc04009a"
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