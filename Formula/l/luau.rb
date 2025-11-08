class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.699.tar.gz"
  sha256 "d5b323aadfe0cd9b44330047bd5b755c26f0bc25b6137fec1cbd389aa5b02525"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe6d1b3b8866fd601e3d3e43c882aee5211f5d9bfe181a4bdd51df44ceeabf1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb91c2537e50bf8d168b20c99255fa25b11db6a267912d4b36d6e01d9f171116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ad3cdbf59e49d4d7e9c0e4ea480e9505d0b34c75390d1d6e7a4a601e091a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ac3404bc9353135ba085772b5874bca5892d1962bc0d7690d7f7e863f6da1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3698a498fd40fe53806ecb9d318f30ca65d91c2559205dab85786f93b880c0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256e758603b846efc220126871f2673aae5c6f7981f27942a0acc8834bd81142"
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