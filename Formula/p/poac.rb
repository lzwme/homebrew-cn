class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  license "Apache-2.0"
  revision 2
  head "https:github.compoac-devpoac.git", branch: "main"

  # Remove `stable` block when patches are no longer needed.
  stable do
    url "https:github.compoac-devpoacarchiverefstags0.10.0.tar.gz"
    sha256 "4bdede67b28f9622c071bef8c7eae76062c9ef2ad122deee49d994668e846288"

    # Allow usage of fmt 11
    # https:github.compoac-devpoacpull975
    patch do
      url "https:github.compoac-devpoaccommite38d0c542538204b7e0522d07c65d0c787cb4eb9.patch?full_index=1"
      sha256 "b1456f819f8079d6e051c95ec7b43dfc42d8f5998e7521e6534047cd2348638e"
    end

    # Fix for libgit2 1.8
    patch do
      url "https:github.compoac-devpoaccommit97b43cb52fda635c75746df27664187fb2f00d7a.patch?full_index=1"
      sha256 "bbe146c76ea9728b46608d0de7c8a5ded732b4418597c9b20a6025a02193bb34"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed85ac75fe9e7ff7fcbb4c40541ab1327da08ed24f247fdfa9e0751b0117117e"
    sha256 cellar: :any,                 arm64_ventura:  "6826d18cdded0f0615581533455eb697362e5fac589694b10473e90433ec5519"
    sha256 cellar: :any,                 arm64_monterey: "a4e3b21cffa00b44e7ff2bff38fbe6e562f5e7346e2932c565696e1e25a051df"
    sha256 cellar: :any,                 sonoma:         "6d362349430d1fc7ed35d2acb3a421d5e35b4a43a01ff9cc34d01f0cb5406a17"
    sha256 cellar: :any,                 ventura:        "8818d6e35f53b129cc278c410b7b46ed212d73f331fbbc8c2c626f6ff3d94683"
    sha256 cellar: :any,                 monterey:       "c8aa21719d69fcdd98c8f416756e49c13ba032fb6af9dd3edaa9c8ee2aa7771a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5d1245d8bfe9ec99d89f6ff4eb9fd878a3ed54f427093dcbc7b17662b9fa8df"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkg-config"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "11" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    # Avoid cloning `toml11` at build-time.
    (buildpath"build-outDEPStoml11").install_symlink Formula["toml11"].opt_include
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