class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.646.tar.gz"
  sha256 "6c9927ebbc1fc57b1ba41dbd8d2c561c10e05e1e00299c49c4b5bdfca4c26167"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5351e36572cd3e92d1d1d5fc606e7387f1d490e6fcacc4b9ee2cd94995ffc1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ff3741f375f2e559cbab102ca1992cf56d8b5ccc87137e5c97b3fbad4828df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a388aff7a6b20deda3ccdc55ca47d0ee859b4628936d42e4b84490a7840f20ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "552f6b0281594f2889e2de6ececa1300d7a1aa8504beb1a3f3da7acd412671be"
    sha256 cellar: :any_skip_relocation, ventura:       "7aaf89c5d1769ac81dc7c0e9912dcd4bb243fb6fb4c7c768bdf0e2bb9d642779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2f4135428bd72c772b3279601e26e395c32f8515a0c430a9ede9149ad5debe"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end