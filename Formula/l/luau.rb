class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.641.tar.gz"
  sha256 "64fde6b2bf2ad9b17ce600306fa02b381772f191909492da7cc3b81a7e36a765"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a86c2c73df4d2d325156cd64e352d192a368adf23755a148d6dc09b465be61a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53c42703a3e2744899c57738454c3d6a5e2e2f295b37fed87fc7c4c733b1d7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d16e0ac8a824840324427e5473c7ef8e7601b2f41748ebec868df170e166a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "1aea0ed309e4631803825ce39c4c8d11dddee9a0e5d43d67fab2e85caf66d6ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1b44ba73bc43590d262394a6718ec763ea7064dbe7a1c136fcbd6d1a89094ded"
    sha256 cellar: :any_skip_relocation, monterey:       "a27bda09b26e2f9d6edcf05f69c1add1abf33d374aa757b3fb5de9f9d6462d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10bcaad7a5f538fc359f3e652bf76023c6480d85953af3caceeb7dd9b018716"
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