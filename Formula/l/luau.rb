class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.689.tar.gz"
  sha256 "d03c79ee496b732c72f405283ffec07185050ed993347e45a0c4a1518c8cb886"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f06092b9191c6c417fb8095d3f5f7a620d487e616d6f64e11efd1b44bf2eabe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbbf9364ac56372cf0a99ac1ca26ef186c9156fc8ad3d6690f52c9d9bcc393cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9cad3b62cc86eac8cde558053eb151177f18d27e91d29a36eff3092d3239767"
    sha256 cellar: :any_skip_relocation, sonoma:        "f56deeb2b6ecab91f720fbe0337c831ab504434f2570aded9336000524ec906c"
    sha256 cellar: :any_skip_relocation, ventura:       "19134458a8cd02704554c437dd14ac1972b17029e2a271229c76e82c40895c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff946ca13e918557818b5fa2543f9533bfadb9f3ad8df1d5529743fe088ca7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83207a4b4b2c6af68e019d89d2a9f383c626d7229b84e3ce70e80e1c53d4aab3"
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