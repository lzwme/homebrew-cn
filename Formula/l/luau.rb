class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.633.tar.gz"
  sha256 "bbfd1a5e969d41fcc9246c2d471816290d7e5887cff6b9a8706e06cfeaab83ec"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fec9c49932dc35b5fdee367a78985cd29598ea075421cf22ad97e8499d0cdbf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13172bec12d0d748d418ce47b657510772b284942a37cd71ac8c1c287cb174d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db0ca758eb9934a3907f81c25d74de508d26a757392c4c06ac8a6b5054f3ac0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd6080ef9177fc62ace5605a7791abad27d8bc2bf33e220569cf3d10f88c2071"
    sha256 cellar: :any_skip_relocation, ventura:        "58eb7dd1051a61ceafd5c27d804d01410394253cebb41d71c482cb714252d65f"
    sha256 cellar: :any_skip_relocation, monterey:       "87516d87b97ce7d67330dc9508a9a5b58df4ffd97b5e3cb37dc0fa6dbccf037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bc710c1d28d0e83888f56f291e658a43c64a6084eeeb94812bfe0e0a224e0a"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end