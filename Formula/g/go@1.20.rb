class GoAT120 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.20.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.20.13.src.tar.gz"
  sha256 "0fe745c530f2f1d67193af3c5ea25246be077989ec5178df266e975f3532449e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e0b883eebe85612544d06bb87d0e375716801288eae245bca1ca8e3cf8eab4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e0b883eebe85612544d06bb87d0e375716801288eae245bca1ca8e3cf8eab4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0b883eebe85612544d06bb87d0e375716801288eae245bca1ca8e3cf8eab4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "32f4da4cf665a4e2121aea852ddc0e8a86d8c974f85fc4d0fdb1c4699569f851"
    sha256 cellar: :any_skip_relocation, ventura:        "32f4da4cf665a4e2121aea852ddc0e8a86d8c974f85fc4d0fdb1c4699569f851"
    sha256 cellar: :any_skip_relocation, monterey:       "32f4da4cf665a4e2121aea852ddc0e8a86d8c974f85fc4d0fdb1c4699569f851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd2da4e7d3a529d3fb57bcebb732cb4eb733f5b3ac0b801d40d2764367a31122"
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