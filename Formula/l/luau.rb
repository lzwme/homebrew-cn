class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.736.tar.gz"
  sha256 "e80f61e402500bf155f9fb260fc4a8f6ec8b7fb2e471b115b7e22111e993da86"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06cc890d9d432f5f100f84adb6d8b1355ed98cd3f3cc64d2de40d28aa33df99d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53684a8ef40618b92f36b129412486509fbc1f9e1a5836db2be5d24e91caf582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca22cedda191bf97379cd54e6802e2649c191237be36505f34b754aad9c1750a"
    sha256 cellar: :any,                 arm64_linux:   "d3c0917f3b53401c6ac5b3597bf49b3c98ca437d6af6412e93f9823bcbad7a46"
    sha256 cellar: :any,                 x86_64_linux:  "f3da6f8569ab8ca1b8e026ddcec2a3db233392f27b2d45b1d14c5148fa9a66b9"
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