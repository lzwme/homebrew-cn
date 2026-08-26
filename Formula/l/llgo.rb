class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://ghfast.top/https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ad31bdf097990cccd96c8703452a59f790ecdc3efd7a0fcf1f6465c026b99748"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f964a7f956ca6d9b514f154c2004fe04789b5ba2ad3e3eed453a0b800a97517c"
    sha256 cellar: :any, arm64_sequoia: "02d0321541dd15706c33b32c5988a0758ffa6cd6c6ff752f3360cd8b0fbf46e7"
    sha256 cellar: :any, arm64_sonoma:  "02e60d16600ad54a55a2216f82819ee66bc01535ce8ef5ceddcc9024b325a2c6"
    sha256 cellar: :any, sonoma:        "0dd707b9ee40e3b7e0d00c16c6af03bf8ea53f0104e2726b341abefd804f29ca"
    sha256               arm64_linux:   "4cc3e750cc7a9e0b9338e4b3c46497446d1ffc5d73ba38e114aac896be4a8485"
    sha256               x86_64_linux:  "4445689f4654eb3f4a63a026bce11b2ec0003a6c12ed6e758b8836093c6963d6"
  end

  depends_on "bdw-gc" => :no_linkage
  depends_on "go@1.26" # TODO: unpin go@1.26 when llgo supports go 1.27
  depends_on "libuv" => :no_linkage
  depends_on "openssl@3"
  depends_on "pkgconf"

  uses_from_macos "libffi"

  on_macos do
    depends_on "lld@21"
    depends_on "llvm@21"
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lld@19"
    depends_on "llvm@19" # Newer LLVM doesn't work with aarch64-linux-unknown triple llgo passes
    depends_on "zlib-ng-compat"
  end

  def find_dep(name)
    deps.find { |f| f.name.match?(/^#{name}(@\d+(\.\d+)*)?$/) }
        .to_formula
  end

  def install
    llvm = find_dep("llvm")
    module_path = "github.com/xgo-dev/llgo"
    ldflags = %W[
      -X #{module_path}/internal/env.buildVersion=v#{version}
      -X #{module_path}/internal/env.buildTime=#{time.iso8601}
      -X #{module_path}/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin}/llvm-config
    ]
    tags = %W[llvm#{llvm.version.major}]
    path_deps = %w[lld go pkgconf].map { |name| find_dep(name).opt_bin }
    path_deps << llvm.opt_bin
    script_env = { PATH: "#{path_deps.join(":")}:${PATH}" }

    if OS.linux?
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end

      ENV.prepend "CGO_CPPFLAGS",
        "-I#{llvm.opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{llvm.opt_lib} -lLLVM"

      tags << "byollvm"
      libunwind = find_dep("libunwind")
      script_env[:CFLAGS] = "-I#{libunwind.opt_include} ${CFLAGS}"
      script_env[:LDFLAGS] = "-L#{libunwind.opt_lib} -Wl,-rpath,#{libunwind.opt_lib} ${LDFLAGS}"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/llgo"
    bin.env_script_all_files(libexec/"bin", script_env)
    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"
  end

  test do
    go = find_dep("go")
    goos = shell_output("#{go.opt_bin}/go env GOOS").chomp
    goarch = shell_output("#{go.opt_bin}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = find_dep("bdw-gc")
    ENV.prepend_path "LD_LIBRARY_PATH", bdwgc.opt_lib

    (testpath/"hello.go").write <<~'GO'
      package main

      import (
          "fmt"

          "github.com/goplus/lib/c"
      )

      func Foo() string {
        return "Hello LLGo by Foo"
      }

      func main() {
        fmt.Println("Hello LLGo by fmt.Println")
        c.Printf(c.Str("Hello LLGo by c.Printf\n"))
      }
    GO
    (testpath/"hello_test.go").write <<~GO
      package main

      import "testing"

      func Test_Foo(t *testing.T) {
        got := Foo()
        want := "Hello LLGo by Foo"
        if got != want {
          t.Errorf("foo() = %q, want %q", got, want)
        }
      }
    GO
    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD

    expected = "Hello LLGo by fmt.Println\nHello LLGo by c.Printf\n"
    system go.opt_bin/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal expected, shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal expected, shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end