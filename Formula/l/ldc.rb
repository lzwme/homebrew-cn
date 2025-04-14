class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https:wiki.dlang.orgLDC"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comldc-developersldc.git", branch: "master"

  stable do
    url "https:github.comldc-developersldcreleasesdownloadv1.40.1ldc-1.40.1-src.tar.gz"
    sha256 "b643bee2ee6f9819084ef7468cf739257974a99f3980364d20201bc806a4a454"

    # Backport fix for CMake 4
    patch do
      url "https:github.comldc-developersldccommit06b2e42a1b8436faae2b7976a1d41a635df116d5.patch?full_index=1"
      sha256 "80fd42d77217b16866e262008f283406bb597fee16cb6ade250d6d27f870ce5c"
    end

    # Backport fix for segmentation fault on macOS 15.4
    patch do
      url "https:github.comldc-developersldccommit60079c3b596053b1a70f9f2e0cf38a287089df56.patch?full_index=1"
      sha256 "44d281573a42e82ecdd48a6381fec4dde7aa6196f314e9eee7b1111ae6c54844"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "36449ae414e34231fc2e2efeb52dfd1440fb8f85661f6e1949a549f26629ed63"
    sha256                               arm64_sonoma:  "8428db33b0d7a88ef5b528a00dd1fad1f33ca1fdb36b3149a281fbfb8cc9f2c2"
    sha256                               arm64_ventura: "1c1cbed780079891dd07f15f77021200b58502baad0595c59721d577f81d222d"
    sha256                               sonoma:        "fb203819c3456a88e723d0d7958e010eeca90db38406b3a2cb100ba12f2476b9"
    sha256                               ventura:       "192c24c114b06e3d7c7dddbec28f029cf22df142e11983421d31d4d865a218dc"
    sha256                               arm64_linux:   "979f2477a03297565bda42f05e52ae9abe85b9f4cac0d88b042b3f5e9e2c1cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88375463fd83a64305e0cd725d6c552852bd53c2a317895bf918861e4d5325e4"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "lld@19" => :test
  depends_on "llvm@19" # LLVM 20 PR: https:github.comldc-developersldcpull4843
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
    lld = deps.map(&:to_formula).find { |f| f.name.match?(^lld(@\d+(\.\d+)*)?$) }
    with_env(PATH: "#{lld.opt_bin}:#{ENV["PATH"]}") do
      system bin"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output(".test")
      system bin"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output(".test")
    end
    system bin"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output(".test")
  end
end