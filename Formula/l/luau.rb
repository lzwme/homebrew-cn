class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.603.tar.gz"
  sha256 "97687486b0ffe8d7a4917e13648a9776ee015ca9e1c10b6da169caec6ca5b427"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19fcaeb41af86780302fda51b07f194ef46b8565692f4e36c7e625d422fbe9f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab82eff82e9ea158e771a96a8f38ca4918b9c44f3776f61fcfe9080ff54000b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b430267ab91b5af2128c35881e4e5440384d4b39f39710d876d11c085107244d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a8f0ca531b883894cb11f97a1fc54735f7de116f66731041b56f74e2d73774c"
    sha256 cellar: :any_skip_relocation, ventura:        "5dbac82a15a2b9b0a9bee4121c5dccb00291161b7e665856c5accea3b53f2381"
    sha256 cellar: :any_skip_relocation, monterey:       "e9cd508679c6d2fbea92e787653bbe275d047cba61c06606ca1eade5eb48e473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5702a8fdbb358e26f06e2fe67066cae03eb766b6a97f0e1f4c523604bbcbd4"
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