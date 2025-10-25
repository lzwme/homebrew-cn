class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.697.tar.gz"
  sha256 "e3f4f90e4ee35ba4264242e84fa496c93c5bd216cb3d16a237c9f17d9573ba43"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1669f0d0c24a51c8744f0ffccc83d71afe946ec4285c2cdae3fd2766a17fc301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c994fac7e533a47e7215abc3eb3a9ce6f19cb3c14c06ad294258827635b65216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0024e64a05f69242956ce19e779f58694966e1417b34f92c1e3dd1187a110a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f72b5c535a8a0d41835c0d28521fd7d226d841835ca72078e7a3c44031a3eaf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48874fc6c55d0c57013710673c1dc14ff75606a7d9f0057566485eeb49371cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e21e16c15dff81771c6988deff9b9e323f3aac1bd1b08310f987144287b039b"
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