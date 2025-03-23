class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.10.1.tar.gz"
  sha256 "4ef8a05ff2739617be48de1eb7cfa3e37bd402595fda6bb6df106aadb6c96965"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dc375813eea8e2f0a6a13aff240857354180997eeb0cc7957a3f1ed94f0da7f"
    sha256 cellar: :any,                 arm64_sonoma:  "dfdd17e6f51ee70236298dbc1ffaf7e219ecabc4a1b1acbe2896ce0dc50e6eb8"
    sha256 cellar: :any,                 arm64_ventura: "dbf3ebebb17e141d4904bc7e454eeb5ee9718a7b3f1b89de02926134cf2d34b3"
    sha256 cellar: :any,                 sonoma:        "1a2bd6b7dc12ddd230b8cf3f61f9ef4d5e464c1c457de2eb5d7ca58e3aec1edd"
    sha256 cellar: :any,                 ventura:       "1c645960c657822c6cd9cbb26c0c4946e7ac5bebf3b87648741da3a22505ef75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca39bdf87775a87194b48ec4b4758c03ac567ca95fffd45212c210c09789c922"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "libffi"
  depends_on "libuv"
  depends_on "llvm@18"
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
      -X github.comgoplusllgocompilerinternalenv.buildVersion=v#{version}
      -X github.comgoplusllgocompilerinternalenv.buildTime=#{time.iso8601}
      -X github.comgoplusllgocompilerinternalenvllvm.ldLLVMConfigBin=#{llvm.opt_bin"llvm-config"}
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

    cd "compiler" do
      system "go", "build", *std_go_args(ldflags:, tags:), "-o", libexec"bin", ".cmdllgo"
    end

    libexec.install "LICENSE", "README.md", "runtime"

    path_deps = %w[llvm go pkgconf].map { |name| find_dep(name).opt_bin }
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

    (testpath"hello.go").write <<~GO
      package main

      import (
          "fmt"

          "github.comgoplusllgoc"
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
    system "go", "get", "github.comgoplusllgo"
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