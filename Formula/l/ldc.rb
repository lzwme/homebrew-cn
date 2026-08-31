class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://ghfast.top/https://github.com/ldc-developers/ldc/releases/download/v1.43.0/ldc-1.43.0-src.tar.gz"
  sha256 "d655aad0daf0ce9a17b2ffffb947bb79ec6968bc7fb88bc918316dbe78c616e7"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "bcde46ad3da3b29561e7b04742b82bc2338dc8c636cd2618187bd06b149de5fb"
    sha256               arm64_sequoia: "12508ae2e08b8e1096a85d5248b75294f5ad4f84402ae4b766023e97ce9e861e"
    sha256               arm64_sonoma:  "e8b40363a3d0f4367c0d1e18ca09b95a26caa08d4212d358fc97943f8b57a305"
    sha256               arm64_linux:   "12512ca6d507b94e41bf459b24a69b914a3fdd4d9e892bd78be6da9e0d200387"
    sha256 cellar: :any, x86_64_linux:  "cd1253c20b0d9003cf04f9261588b6c7272089ae5a6a1aa84208cd7de2ea7587"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "lld@21" => :test
  depends_on "llvm@21"

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://ghfast.top/https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-osx-arm64.tar.xz"
        sha256 "157267042f10b047210619314aa719b4f0bf887601e93b1c634aa1ecb3c546e4"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-osx-x86_64.tar.xz"
        sha256 "5bcff48b63c56a45dbaacdb0c5bddc8ea6be86d4a0c7b2c7c8318e047f721181"
      end
    end
    on_linux do
      on_arm do
        url "https://ghfast.top/https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-linux-aarch64.tar.xz"
        sha256 "1c4b950a13d53379ed4f564366c27ec56d6261e21686880d70c7486b3e8c7ba8"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc2-1.41.0-linux-x86_64.tar.xz"
        sha256 "4a439457f0fe59e69d02fd6b57549fc3c87ad0f55ad9fb9e42507b6f8e327c8f"
      end
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.d").write <<~D
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    D
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    lld = deps.map(&:to_formula).find { |f| f.name.match?(/^lld(@\d+(\.\d+)*)?$/) }
    with_env(PATH: "#{lld.opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end