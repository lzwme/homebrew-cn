class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.12.src.tar.gz"
  sha256 "c5bf934751d31c315c1d0bb5fb02296545fa6d08923566f7a5afec81f2ed27d6"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.20(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c142abdda3f381d8520334669a15864062b82a0382f32ed383cf146f2c71c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c142abdda3f381d8520334669a15864062b82a0382f32ed383cf146f2c71c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c142abdda3f381d8520334669a15864062b82a0382f32ed383cf146f2c71c3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ee717bb9626a2dc25c3b58cbe7a66578ba63eb467857e2c8320b227902edb74"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee717bb9626a2dc25c3b58cbe7a66578ba63eb467857e2c8320b227902edb74"
    sha256 cellar: :any_skip_relocation, monterey:       "8ee717bb9626a2dc25c3b58cbe7a66578ba63eb467857e2c8320b227902edb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "754cee017d086502832a11785aba47e4f703b09f43e0c489b1cae9bb09175024"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~EOS
      package main

      /*
      #include <stdlib.h>
      #include <stdio.h>
      void hello() { printf("%s\\n", "Hello from cgo!"); fflush(stdout); }
      */
      import "C"

      func main() {
          C.hello()
      }
    EOS

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end