class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.710.tar.gz"
  sha256 "eac7e7f8c686733a68b766920c970c7446d5fd6bbcb1ac015da0082962d54bf8"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5b0d9313d304fc91740ee6ac7f3aaffa70de383b0df822014acf430629dd84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1166921bc054e0a2d1c6b16fc881ee9b09139bc0a50d1fc2711e6555b49600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7212ec32d0dd4ae8ebee0095dfd0343287c4a362f4ad4ef956998f889d312754"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65ad072efb5174807f25103faee44433f143081e785986b805d16e51d3a1e1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0acf103198598300e976a72ca936f73ebdb03ff6ec2ca60769f2010f706ed283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959c237268e737132d1f85fc14ff07e0c200e3b5327a2cbec4aeef370dc548b4"
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