class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.11.3.tar.gz"
  sha256 "6e51c300d49b33ce66f562b721fcf4f27d7ed6502382682d02b83786ba49e313"
  license "Apache-2.0"
  head "https:github.comgoplusllgo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "301657dfac614b209cd41e7aedd01cf62825c8e116646ee93d0e527425be39ef"
    sha256 cellar: :any, arm64_sonoma:  "58f7518f88c21c764fbe885a02327514603d452675a457da96932d8036bd7d44"
    sha256 cellar: :any, arm64_ventura: "a658c43e1e63d797813cb58bde26a6f650adfd967614501b4899b67909ed5e35"
    sha256 cellar: :any, sonoma:        "adc0711a8f6bd9a31d4d17e8e50e72d29748428006b5816bccea197bb0c64bf6"
    sha256 cellar: :any, ventura:       "019af6713d1f25c979971a7759d5b50fdd2f25b4d41eac2bf93087a98863fb64"
    sha256               x86_64_linux:  "84a8c66af302faace3159e60537e9f1b7e40cbd1215deb3c5c4ef46d0d5d535a"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "libffi"
  depends_on "libuv"
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on "openssl@3"
  depends_on "pkgconf"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def find_dep(name)
    deps.map(&:to_formula).find { |f| f.name.match?(^#{name}(@\d+)?$) }
  end

  def install
    llvm = find_dep("llvm")
    ldflags = %W[
      -s -w
      -X github.comgoplusllgointernalenv.buildVersion=v#{version}
      -X github.comgoplusllgointernalenv.buildTime=#{time.iso8601}
      -X github.comgoplusllgoxtoolenvllvm.ldLLVMConfigBin=#{llvm.opt_bin"llvm-config"}
    ]
    tags = nil
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{llvm.opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{llvm.opt_lib} -lLLVM"
      tags = "byollvm"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "-o", libexec"bin", ".cmdllgo"

    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"

    path_deps = %w[lld llvm go pkgconf].map { |name| find_dep(name).opt_bin }
    script_env = { PATH: "#{path_deps.join(":")}:$PATH" }

    if OS.linux?
      libunwind = find_dep("libunwind")
      script_env[:CFLAGS] = "-I#{libunwind.opt_include} $CFLAGS"
      script_env[:LDFLAGS] = "-L#{libunwind.opt_lib} -rpath #{libunwind.opt_lib} $LDFLAGS"
    end

    (libexec"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bincmd).write_env_script libexec"bin"cmd, script_env
    end
  end

  test do
    goos = shell_output("go env GOOS").chomp
    goarch = shell_output("go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}#{goarch}", shell_output("#{bin}llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = find_dep("bdw-gc")
    ENV.prepend_path "LD_LIBRARY_PATH", bdwgc.opt_lib

    (testpath"hello.go").write <<~GO
      package main

      import (
          "fmt"

          "github.comgopluslibc"
      )

      func Foo() string {
        return "Hello LLGO by Foo"
      }

      func main() {
        fmt.Println("Hello LLGO by fmt.Println")
        c.Printf(c.Str("Hello LLGO by c.Printf\\n"))
      }
    GO
    (testpath"hello_test.go").write <<~GO
      package main

      import "testing"

      func Test_Foo(t *testing.T) {
        got := Foo()
        want := "Hello LLGO by Foo"
        if got != want {
          t.Errorf("foo() = %q, want %q", got, want)
        }
      }
    GO
    (testpath"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system "go", "get", "github.comgopluslib"
    # Test llgo run
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n",
                 shell_output("#{bin}llgo run .")
    # Test llgo build
    system bin"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n",
                 shell_output(".hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}llgo test .")
  end
end