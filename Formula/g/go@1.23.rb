class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.6.src.tar.gz"
  sha256 "039c5b04e65279daceee8a6f71e70bd05cf5b801782b6f77c6e19e2ed0511222"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.23(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4db4579df6a906f27611a27613a8d6583292a50534470d101e276e5c4ee31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4db4579df6a906f27611a27613a8d6583292a50534470d101e276e5c4ee31b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf4db4579df6a906f27611a27613a8d6583292a50534470d101e276e5c4ee31b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4654e00aa7967d9c8cf325253d1f82896f2a6ea40de389879cdfffa235e374af"
    sha256 cellar: :any_skip_relocation, ventura:       "4654e00aa7967d9c8cf325253d1f82896f2a6ea40de389879cdfffa235e374af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ba9579754a0e0a4e6a6840dff51ad36c78cd8e4a3e820631083f09d32cc12b"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
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
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    with_env(GOOS: "freebsd", GOARCH: "amd64") do
      system bin/"go", "build", "hello.go"
    end

    (testpath/"hello_cgo.go").write <<~GO
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
    GO

    # Try running a sample using cgo without CC or CXX set to ensure that the
    # toolchain's default choice of compilers work
    with_env(CC: nil, CXX: nil) do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end