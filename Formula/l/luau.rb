class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.732.tar.gz"
  sha256 "99768b0a47c2817eb2b8e177939571b7e994f1739e823f65fbc211cb873ce321"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8354b1fe89838310cc709a5b5c1258e0240d035a6143db3dbe615bcb244361f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4176a9cb2e40327d47eb1d4d754d75ee229a5db4d8aba7cb8163eb14b4b03bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff5287ae5be08199d6ed5aab93cf286ab502253b3b3f2e5ad774a98c7b07133"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9dcb4bda36bf1b57da7a2f3aa57813e6ed97b4000ac9926313b329a32bf7e4b"
    sha256 cellar: :any,                 arm64_linux:   "407032093d619f6923038b2728bd708ce6db74b01e3a2fd157592727b7adf212"
    sha256 cellar: :any,                 x86_64_linux:  "4d0c784e0bb986d69202bba3eea0b14dbeb00368e9ed047aca0e800e7813d56d"
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