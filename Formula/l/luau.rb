class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.600.tar.gz"
  sha256 "5d56c18f8bd063ce9516ee9ca3fe22670187f26daadebbe356d68070371880a3"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "105d504a51cdcc6be39906a040baa3cca2901f6db89075bf9a0410d0b4e10d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e1216fc1f2aba140638745ad16097d26a3a18f00785b69954a83a60ea22ce50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8409196c583a2bfa576da7da81fa9713887f424ce2f71564c6132fb666d6b9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5342040adfe35620bbe7314c1f8eba5c3e2bd4b104791b69051b5fa109c612b7"
    sha256 cellar: :any_skip_relocation, ventura:        "e87383fa4a0ed693fa98e71cc1017c98a51fe08f5501427085557b3af9dbf04c"
    sha256 cellar: :any_skip_relocation, monterey:       "29b8278af3dc56d6a751aee85295ee03cc57dfc18756b46ade4259de84b68b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278b9097bc74b07f0ff1de37e29d89530b52daa0014b1d6b949defed0dd9bd75"
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