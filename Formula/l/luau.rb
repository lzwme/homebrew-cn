class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.706.tar.gz"
  sha256 "f4968e32947f7aaf65ea66efe803918c539239f00d95eb329de7cea16573be3d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0514ceae7b988da72f457b3ac268c8de8e61d72749bb2fff4efc9d2f51ef69b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60a025c108d6db20fe408d14c511b433c8ffc986940ac3d1f852b96875182f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce4659b5761e8a135961db9e89e48e03e6f15973d7aaac7c842fd1d6dbaa3ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "10bff201de11a8facd7f0012990dcb15aed03c5e1d8db84d31f1d65a8854391c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ddc89b4402a62b358f12401acc57a7608e633b8111c88052ad9d3f3730368e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5140fa140fa639b29c7b047e622ddc2879ab7b6cbf8bd31d94cd33f4fdd99991"
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