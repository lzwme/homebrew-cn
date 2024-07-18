class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  url "https:github.compoac-devpoacarchiverefstags0.9.3.tar.gz"
  sha256 "122aa46923e3e93235305b726617df7df747ed7a26072ccd6b87ffaf84a33aed"
  license "Apache-2.0"
  revision 1
  head "https:github.compoac-devpoac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "950bdf30984da856fded20152c69d7c0969fbd460fb02f5bed17fa6d7c1d93c2"
    sha256 cellar: :any,                 arm64_ventura:  "2bba39178e9771203c7325bec27dd0c54dc5a55baf07569f1c37c704dd3d6210"
    sha256 cellar: :any,                 arm64_monterey: "74c6fd99a31d66da776a924c245c1fb847a8ab6feb0c94303298b8d72a581707"
    sha256 cellar: :any,                 sonoma:         "407a88b152199b83acd6bece2c3050ebf287c658d57727ca69d99d6fb802a323"
    sha256 cellar: :any,                 ventura:        "36a8ea717003bbe90f456807a6a4061bd029744cf0b72c6d7e63795670f48b40"
    sha256 cellar: :any,                 monterey:       "fe99fd07a0a88ff6f2814199b46252260495c4f55f719add32fd3980d96ff35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "074a27081cffbeb8c7ef465a17dec2adb2c5ed9aa2b25b4ddb2d31afa619db9a"
  end

  depends_on "curl"
  depends_on "libgit2@1.7"
  depends_on "nlohmann-json"
  depends_on "pkg-config"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "5" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}poac run").split("\n").last
    end
  end
end