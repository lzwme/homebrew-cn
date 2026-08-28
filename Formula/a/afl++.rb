class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://ghfast.top/https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.02c.tar.gz"
  version "5.02c"
  sha256 "118415843e5d289d63bd6d8f2252c18212978f15ac9e86acbbc75766cd45acde"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c65ca15fb74976ee9bd2cffd7181a4e1b6f32644771be10fc2b3159f50b9cd89"
    sha256 arm64_sequoia: "28973e03320f7def0fbdfbb932e17bd1a7c768563bb42d3ed3c8a2a99bf7156b"
    sha256 arm64_sonoma:  "1eedd9b191dfa4b929a3473ae3da5db3733c4563917db9675d87647c703d1dee"
    sha256 sonoma:        "c229850b10b570a40e0ff8f63bd93bb9f686ebc68db277df7aa71ebb27c1803e"
    sha256 arm64_linux:   "56174c803fd4e44c50a17847b130dfc070bf28a6c497c2739a48adbd232b2c1d"
    sha256 x86_64_linux:  "bee15548adfe3fb14f5a2935e1901d268fc9c86d397ca720f4b6a67122650b74"
  end

  depends_on "coreutils" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  deny_network_access!

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    llvm = Formula["llvm"]
    make_args = %W[
      PREFIX=#{prefix}
      CC=clang
      CXX=clang++
      LLVM_BINDIR=#{llvm.opt_bin}
      LLVM_LIBDIR=#{llvm.opt_lib}
    ]

    system "make", "source-only", *make_args
    system "make", "install", *make_args
    return unless llvm.keg_only?

    bin.env_script_all_files libexec, PATH: "#{llvm.opt_bin}:${PATH}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~CPP
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    CPP

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end