class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.688.tar.gz"
  sha256 "e6310fdb23adbb0d6fafb121d68417e27eac09e80292347d2bfe98292b24bc75"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47af6a223bfdd33fb0bd740a788b44764f8c7d521d44096500339b0462d57b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521e1aae5be02fd78469bdb45b5e160919d229a1600e8ecc82329d8b19619ef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e47cc47d792c62d279992682e7246111ddb3b70f38aa8c8ab6514416b34b176"
    sha256 cellar: :any_skip_relocation, sonoma:        "08de62fabff8beb0003be36257ded70380a4ffc03401e56c81b6a75ff347fd14"
    sha256 cellar: :any_skip_relocation, ventura:       "b2b4659bca9a6f840e32e3e8e1dca7a056d70582fac70802ecfad8b187e6c9c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c75ff3f8873772dcdde2033e142ce68918958b9a68e6699487725fce3d0c84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2b704fab063dc3ffd4fa735e6028d0cf3991b9cf1d66d0f00c54c7cf662d08"
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