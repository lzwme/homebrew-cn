class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  url "https:github.compoac-devpoacarchiverefstags0.9.1.tar.gz"
  sha256 "f2e14d1e13b4a036081d7d33c283a6ffc2a8382a541ba0e9553232ccc31f507b"
  license "Apache-2.0"
  head "https:github.compoac-devpoac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b689977515bb674531c1db85bec8250198a097626510d425ae92ff680d2206cc"
    sha256 cellar: :any,                 arm64_ventura:  "42a410e5c74a18ed0a1acffa2c85ac581fccd487d3053d55f6db0548cfddbe7e"
    sha256 cellar: :any,                 arm64_monterey: "4ccb6de017801934f2b4cbf83efae3a1a62c137a51643b1b72546db6258b19db"
    sha256 cellar: :any,                 sonoma:         "b1348056c4bd03c116e2e880b8945195ceb02e4b0dff2dc7e3090eaa23ee5108"
    sha256 cellar: :any,                 ventura:        "29b7e054f21d29d5bfbc7322ececedd21807696d3834ee51651e6a0472d45cce"
    sha256 cellar: :any,                 monterey:       "82195f0d6566a157658361749138033a12a6c31e51bb7992c16265342adbdf64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce6af92f7d4a24512b94b87c37738f3ec0b22fdf0c75ac78a3856a9dfd5ad2b2"
  end

  depends_on "curl"
  depends_on "libgit2"
  depends_on "nlohmann-json"
  depends_on "pkg-config"

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