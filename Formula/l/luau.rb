class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.707.tar.gz"
  sha256 "37c25566281ba9c47755be300e36e40fdb941ca286e1b03f726a299ba0bae105"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2c19f59b7a41d443e85464f9d478eaf9e0222c88aec703fdfd04a9183b601ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d47a496dc65be3c8af5ad37be04ca2e3b2e1523719073c8b4e9f2be9ddc6fc11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61924f7fb42fc5b42835074568070f41fac8f50546905c399ee861d2c6625c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "904f3ea7ab67a041bbf5b5a93b20eab83f5c6d5a66a785cf2cda01170fbf00bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff3274a8f51b79a9bb2dc0d77b2a8d396f4ec93ee2860871bb3cbc252a1773b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a0dfe0579f3b154544382c1d7a217a5df899acd35b0d4f82494449edd35684"
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