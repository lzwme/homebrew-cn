class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau.org"
  url "https:github.comluau-langluauarchiverefstags0.656.tar.gz"
  sha256 "c5523f2381b3a107a0a4f3746e27c93d598fcac4d49a9562199e55c3c481fb10"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aa635923792f9161b105272fb696a76a1825652a1a7fde4cf08e4449a69c825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8031395ef92db01117ea304e87d92e0ad2c6f405f33daa5c6ec9478aead2e7d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12c761c35ddc40edecb013f338f4e7e0a16b5eb81815cae62859f7c8438268bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "063b3b5820c0d64e68e3908da452a642f6d33c82c350a3daf8fbbf9d4951c4ae"
    sha256 cellar: :any_skip_relocation, ventura:       "6ac3726cc19a9d945245ea2632efed82ab5ac39a03326e503747b425ce529b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8271d207e090f28b7db162bfd7f6075c93d1f6d6ff36dbd29c3e25ebebd9ff2"
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