class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  url "https:github.compoac-devpoacarchiverefstags0.10.0.tar.gz"
  sha256 "4bdede67b28f9622c071bef8c7eae76062c9ef2ad122deee49d994668e846288"
  license "Apache-2.0"
  revision 1
  head "https:github.compoac-devpoac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f09825ec68f5e41ba291fedca8088eaa70c1f8f54148dc1a8ff13c8039a70c13"
    sha256 cellar: :any,                 arm64_ventura:  "fc861f9f7b998d16bfb2ee90116463911b398646f01a2032edbdbe107a08303c"
    sha256 cellar: :any,                 arm64_monterey: "a80cd29faa3fcfccea17f7c12cd360c8af91f489bced5db3562cc8d5815a6571"
    sha256 cellar: :any,                 sonoma:         "dd54802b36c53eb11b2a6b2782b4daeeb90f313e21de9d725b9d3d55cd296543"
    sha256 cellar: :any,                 ventura:        "395edebd2bffd25c1f8ec925f1afbca5322581db0f581ca08cf73ea02f0f6bdc"
    sha256 cellar: :any,                 monterey:       "4f602413b9a092fa144eab38b22cf69c42deb6f96e9f5d40d5ba6d00aced4e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0ce0818ff8f0c64e459b859bc139c481e2bb796db206f02bf94dcaf2a77d4b"
  end

  depends_on "curl"
  depends_on "fmt"
  depends_on "gcc" # C++20
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

  fails_with gcc: "11" # C++20

  # Allow usage of fmt 11
  # https:github.compoac-devpoacpull975
  patch do
    url "https:github.compoac-devpoaccommite38d0c542538204b7e0522d07c65d0c787cb4eb9.patch?full_index=1"
    sha256 "b1456f819f8079d6e051c95ec7b43dfc42d8f5998e7521e6534047cd2348638e"
  end

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