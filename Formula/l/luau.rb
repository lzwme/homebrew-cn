class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.654.tar.gz"
  sha256 "b40d75580df0e23fde5d4bbe43806c1098a32ac59902895f367ff2a0c41c013e"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a8f8ca1d3c18f45e7c1ebec46ddbeb93d671a1d2fca281a2bc8543630e82177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5f7b236072d9a455ef3738e5b1816fbb7f1770d5317e0cdcc05bbf55b2f586"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e233fb80d3954780249dccb5af4521e549b7566bd327309df979e7801a9e5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c836981ba6a8ea691fb3be01d3b7cda72c76c0bbbbe27abd8bb4c09490698cba"
    sha256 cellar: :any_skip_relocation, ventura:       "15eee4f3874cf25e1ae0ce8c5484cb9036b2f107ccd18e8996f2d36adb0d1c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e16ac8a50d3b5484e4981f91cc8028f88e9f860d60d8c007c8d88c571bb2c19"
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