class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.726.tar.gz"
  sha256 "8a5fb8031bd34f1dc036e2f02468fc2f2e49535e9fe94a52f4cb348d3946b488"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d7985aeeaefac0c5ced13ab1e6c4e9e6264c97a9232d98db0a064f3fe0eded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02cdb6119caa6a7804afdc8780e2cef711657b76fbf819a9c6fd31696c2d3ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe58a7ffe1a321a2d9c12bb576aa8d8cd81eed8a8f2db38180a68f9abc3b35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc0de2b1ab8a6779f316bae15c12ba222134c63af64ca7f21672f2363fdea66"
    sha256 cellar: :any,                 arm64_linux:   "5ef7a4d6689b10f2f1b7fa81c6c2cc79fddb29a925fc0559a23114bd8af5b8e5"
    sha256 cellar: :any,                 x86_64_linux:  "716174ebed19790d72d31c2e7b0c80c9ce5aa50d834eb21e97491b02bebc48d2"
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