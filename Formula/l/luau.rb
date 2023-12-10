class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/luau-lang/luau/archive/refs/tags/0.606.tar.gz"
  sha256 "1b5fbe2204128a729f2ad794029e98cb708efb41078d4e8c6087e7435a46de27"
  license "MIT"
  head "https://github.com/luau-lang/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0799550be922ff46ec6c78f13731c4000635003762139217a844d0226f49c78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e11ce6cc8675a14f3ca67f6f4d94e392517555ac64ca708973f441f7ddfba0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27fa188b0a044ab9ccf2211dff10e27d99554f1b8d098c1235eacde6a0b1456c"
    sha256 cellar: :any_skip_relocation, sonoma:         "edb9ab68f6404b44ea75360709adfc41b057659dc1bd1508551973b7eafde80f"
    sha256 cellar: :any_skip_relocation, ventura:        "1118946aee6fd20532770ab5ae84e6050ac3097bb2379b6ad881e034a6b70bfb"
    sha256 cellar: :any_skip_relocation, monterey:       "9b9bd31212aab3c1da7d6b1d55905951e39f4c8676e25fef14fa9de0408b45f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a565cfdd4f7c20956474ad9f3e34d50529dc7581508ad7813fffec4fbe54897"
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