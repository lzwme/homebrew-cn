class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.698.tar.gz"
  sha256 "88a0b345fc864daeffc5f22033955b9e5d57fd03db5dcca8164337f572336e70"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75c3b6b6a59ad55eea5a4b989b559739779546a5dbaf8e919384bd15d503cc07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87697672eab68fd6d9a5db1ca455c7625ec41d4fd034e9a19eb35b443c205df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1826e68d1ccf5a5df3a024ae030ddc5ca29fba3815f0dde8cf15141fd11d3966"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc80c478b8bb628810c03c7e82b8cc07fdd5fe70236dd2afd7ef2fa3e8c4a0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21aa3161a38d11a0222280bcc09a453d1c073026e35ce4b5047e83c81109277d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0187358e36217661ee091247620ae752d9bf699dbe4fc6b1fbf2ba95f27616e"
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