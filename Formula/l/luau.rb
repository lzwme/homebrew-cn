class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/luau-lang/luau/archive/refs/tags/0.604.tar.gz"
  sha256 "1ca48bd8a7ff1bb981afdafe5badd1ff457459c88bbc7db808497e0974f1b9d4"
  license "MIT"
  head "https://github.com/luau-lang/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec2c5ac784b444ff2d723443908bac5a5a2767dd615068ea5d16136da5868048"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "166abf29f9071f47dc2ac369827e6d4447abd287fdc6c2d755da5b19c1b31d2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d01f7605e32dc862879eca4e363c4497ad4672e6b514fdf72744ca9ce8f75df"
    sha256 cellar: :any_skip_relocation, sonoma:         "b341010b980315b51748d4332df2f58708ee6e5747c9fe5fb1a1dbdff52fe86f"
    sha256 cellar: :any_skip_relocation, ventura:        "005fc9ca1d7fa28499ae6d12e4c2ebf275f618a770ddad644d2ab7480e4ea4e7"
    sha256 cellar: :any_skip_relocation, monterey:       "b9767b757dbb76dbdad4a24c903b01529f9f672647dd19d43dfdcffd75549422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d4df4cd32073129bdcab25ee96fbe7774969af20e0ca8389c2b2f1775e5578"
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