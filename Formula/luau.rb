class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.578.tar.gz"
  sha256 "c81b3e54fac4dcb9bc1f2deb095a530dd530cd3d84f55d424cef788f866f4ae2"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee30dcf6e918df6c05a7b46c3eaf8fa16237dbd2392c4923a12b3d5166773cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e28329246f0c783845573d173b702c85d021d949edea54e4f3d025e7838e1ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78cbf10911b3ac9336daa65f9d7992cb8af6185708453e657d88c3668875848d"
    sha256 cellar: :any_skip_relocation, ventura:        "069c0133c69c77f1b66fe1f5fe1f0775fd5e45be4e440e7f8085b086616b2a51"
    sha256 cellar: :any_skip_relocation, monterey:       "6e6f808dce022bf6facfb240d5befe4035626d453a22073924961f39c64e5620"
    sha256 cellar: :any_skip_relocation, big_sur:        "baa2f2eb40ed38dd9f6a63c6c185e638f7dad0c768cf4580cebf8e6be4a1c04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026a1a5015f0fe2d25148109d1b26b968f542132cb0c3844a770c52f39ad3ca2"
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