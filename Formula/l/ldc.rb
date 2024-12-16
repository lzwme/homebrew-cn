class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https:wiki.dlang.orgLDC"
  url "https:github.comldc-developersldcreleasesdownloadv1.40.0ldc-1.40.0-src.tar.gz"
  sha256 "80a3ddd7b7292818cdf6c130e55f1246a19b5fce96139a49b45ccf4e2be99e5f"
  license "BSD-3-Clause"
  head "https:github.comldc-developersldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "620f2799a1fdce0f0023f4340586b32104fc53fb4e00137b86dd1e372ffd80df"
    sha256                               arm64_sonoma:  "679f08ffed1f10be8190a801615f15be35c043b43046c6e1b8a2ac1d2ac3fd3f"
    sha256                               arm64_ventura: "56dfc84a29361fa61fbb8d3d2ce7b09bfcdc5d5461f6180652cc058986d5302e"
    sha256                               sonoma:        "71623961529f14c0265e5d354154a8707aef890a051a0f43c96bf550edf88349"
    sha256                               ventura:       "5f68684249a9eb9d5cf54f5329f254c3eecaa6ecddcf39311f7661df64946911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9312304f8ecc17678fcd62ee2bf020ae67e860671953c81c5cb7b249dd2cebe0"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm@18"
  depends_on "zstd"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https:github.comldc-developersldcreleasesdownloadv1.40.0ldc2-1.40.0-osx-arm64.tar.xz"
        sha256 "04ebaaddfadf5b62486914eee511a8cb9e6802a7b413e7a8799d5a7fa1ca5cb4"
      end
      on_intel do
        url "https:github.comldc-developersldcreleasesdownloadv1.40.0ldc2-1.40.0-osx-x86_64.tar.xz"
        sha256 "90802f92801b700804b8ba48d8c12128d3724c9dbb6a88811d6c9204fce9e036"
      end
    end
    on_linux do
      on_arm do
        url "https:github.comldc-developersldcreleasesdownloadv1.40.0ldc2-1.40.0-linux-aarch64.tar.xz"
        sha256 "28d183a99ab9f0790f5597c5c125f41338390f8bed5ed3164138958c18479c82"
      end
      on_intel do
        url "https:github.comldc-developersldcreleasesdownloadv1.40.0ldc2-1.40.0-linux-x86_64.tar.xz"
        sha256 "0da61ed2ea96583aa0ccbeb00f8d78983b23d1e87b84a6f2098eb12059475b27"
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

    (testpath"test.d").write <<~D
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    D
    system bin"ldc2", "test.d"
    assert_match "Hello, world!", shell_output(".test")
    with_env(PATH: "#{llvm.opt_bin}:#{ENV["PATH"]}") do
      system bin"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output(".test")
      system bin"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output(".test")
    end
    system bin"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output(".test")
  end
end