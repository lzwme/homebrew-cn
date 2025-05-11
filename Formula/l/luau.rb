class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.673.tar.gz"
  sha256 "7587065619c1e63e781dcec895d9df9d8286730016d1ce2e51408f2b7e639314"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8389f4f6ca16c43f280b76c6300c8a3efcdc9d7b836022c26da67ddc85774d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf325cbc685f669853db8d14a710844c2738ed7f89f7c1e7d2d3b5687a913ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d396499134fe9ef7773e4131d2e05408f4fed3dde55f1b9e29c3c7ec216859c"
    sha256 cellar: :any_skip_relocation, sonoma:        "96eb28dd46713ba04521675f7963c67b6d7990eb35104ac054ba95165b255992"
    sha256 cellar: :any_skip_relocation, ventura:       "10354dd9e6fadef0747e17c0007f8a5f514de3aa3981a4b2a76cd36d5a259806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81815c5c2d2b7d87dd42a5a00eb9e2d3ab67c348da55851ec8be35360661a702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4750f18ba0da6dbd39a4c31ed8d89cd367e773695f28a1f56fcbde6bb640c3fe"
  end

  depends_on "cmake" => :build

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