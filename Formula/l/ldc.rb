class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https:wiki.dlang.orgLDC"
  url "https:github.comldc-developersldcreleasesdownloadv1.36.0ldc-1.36.0-src.tar.gz"
  sha256 "a00c79073123a887c17f446c7782a49556a3512a3d35ab676b7d53ae1bb8d6ef"
  license "BSD-3-Clause"
  head "https:github.comldc-developersldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "707f8d47e36ecc8c2c617f22890a62ef3d93f558a562cabfb3921f25d886832a"
    sha256                               arm64_ventura:  "0a405044071166231e8a8bf170a9ef46219356e39201be14777ecb78e3fe1795"
    sha256                               arm64_monterey: "116928c0acf77786e578fd6aeeaf046950e17369e01994090c7e9726b138c3b8"
    sha256                               sonoma:         "61c543e1d598bc2a066a09959db409223a51a547506a5aecaa738961fb5d4a2e"
    sha256                               ventura:        "87e332586ec67c20248606d00867affae0066be8a5454947a1cd9df08d9821e1"
    sha256                               monterey:       "05ce4741765dde73b1e82c46292efb80d6a16ef504c9ca356ba7042a63753fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce022d1b33c2db8c03ae7352d3a154daf11bc48306576a90c5427a59883bf3d0"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https:github.comldc-developersldcreleasesdownloadv1.36.0ldc2-1.36.0-osx-arm64.tar.xz"
        sha256 "ba8440e2b235b3584bc129de136563996db91cd0a35e10bcccf316bee3f23a98"
      end
      on_intel do
        url "https:github.comldc-developersldcreleasesdownloadv1.36.0ldc2-1.36.0-osx-x86_64.tar.xz"
        sha256 "7740fefcb32c19c23bf5ce4dea6e5412329f27ffa511c4101dd96b1f44999429"
      end
    end
    on_linux do
      on_arm do
        url "https:github.comldc-developersldcreleasesdownloadv1.36.0ldc2-1.36.0-linux-aarch64.tar.xz"
        sha256 "11cb6c554b351a00525089659c97a0e6fc568b1814e69407600315997d1852eb"
      end
      on_intel do
        url "https:github.comldc-developersldcreleasesdownloadv1.36.0ldc2-1.36.0-linux-x86_64.tar.xz"
        sha256 "2d418462d1c3909f5889298d97de061d023850a371ea9d418fc3fd2d4b7e8b19"
      end
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    ENV.cxx11
    # Fix ldc-bootstrapbinldmd2: error while loading shared libraries: libxml2.so.2
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib if OS.linux?
    # Work around LLVM 16+ build failure due to missing -lzstd when linking lldELF
    # Issue ref: https:github.comldc-developersldcissues4478
    inreplace "CMakeLists.txt", " -llldELF ", " -llldELF -lzstd "

    (buildpath"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}dlangldc
      -DD_COMPILER=#{buildpath}ldc-bootstrapbinldmd2
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Don't set CC=llvm_clang since that won't be in PATH,
    # nor should it be used for the test.
    ENV.method(DevelopmentTools.default_compiler).call

    (testpath"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin"ldc2", "test.d"
    assert_match "Hello, world!", shell_output(".test")
    system bin"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output(".test")
    system bin"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output(".test")
    system bin"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output(".test")
  end
end