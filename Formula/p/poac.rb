class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  url "https:github.compoac-devpoacarchiverefstags0.8.0.tar.gz"
  sha256 "ebade39fcbfea45407c724e5193d2f280da0386a96fdba79b0de241bc702b44d"
  license "Apache-2.0"
  head "https:github.compoac-devpoac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75d7aa618df9d09791e2dd79cdc67d4ebfbad7420b9a373226991bfd46e26ae4"
    sha256 cellar: :any,                 arm64_ventura:  "fb8a3b3bea7ff113781b86779cacc3b6fc4a182d7778974a704da29714bdb407"
    sha256 cellar: :any,                 arm64_monterey: "b8201556635fa975d1f3af2b70b57ed99301d7d5ffa48b26829a3a7c41aaa060"
    sha256 cellar: :any,                 sonoma:         "c991f1888b65918a553f7ab5a0ff72adfc97dcb5f6dde726261df11d31fca4ff"
    sha256 cellar: :any,                 ventura:        "f3a77a7f585ca6e77f1386e8d98710eaaf18847868c9ce0d0583cb2f20ec492b"
    sha256 cellar: :any,                 monterey:       "37b93bf852ae7c27c78db0e625c02eaea05911a4fb005bf8a4c763af9f0ba9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cfc413b04351257442c6e7833c54bc58026c801aa5952954ec01a55cc9ad54"
  end

  depends_on "libgit2"
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
      assert_match "Hello, world!", shell_output("#{bin}poac run")
    end
  end
end