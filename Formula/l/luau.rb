class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.709.tar.gz"
  sha256 "61a70b10f5487abb57c7585a8d2c44dfbfd7c1d831546ad297699d6ae29e7231"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a59e2ac654969fc37bc6dbf2c1f1b6028d3a229060271e9af9036d47ac49120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e22a7a43d0e8c56af8ad9ea0b5edf79e1e69a676d135e6e2c4908340f9649ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcfad30b6d5b714a215bdfd4d73c496c614d1dc0b355170dfae2cf7330efbefa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ceefde4ad9a23197066b33633344fe0779da0010a4369f5d293269872dbef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2611ba6e823ca1e30ebc32c40d9f3d17f2331c7a5f075c63dcef436dc97275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a451d3f7173e9b395eec81c40b9a8d063ec73bbc8211edd5a470e34079bfc2c3"
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