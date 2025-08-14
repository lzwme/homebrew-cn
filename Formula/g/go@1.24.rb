class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.6.src.tar.gz"
  sha256 "e1cb5582aab588668bc04c07de18688070f6b8c9b2aaf361f821e19bd47cfdbd"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.24(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374c15cd482c42ec3d9a30803e48e18378f171fb5330374ee3565b10baf8aa99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374c15cd482c42ec3d9a30803e48e18378f171fb5330374ee3565b10baf8aa99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "374c15cd482c42ec3d9a30803e48e18378f171fb5330374ee3565b10baf8aa99"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c8d3d799e72aa26f572efd6c02ed97cb47c8a9a0a5a31f945fb97b49f3458c"
    sha256 cellar: :any_skip_relocation, ventura:       "f8c8d3d799e72aa26f572efd6c02ed97cb47c8a9a0a5a31f945fb97b49f3458c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcacb0b26060f6951089b4def084a8886ec760cc00934a87057a09d38cbd3590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ee2366a464e59ff4f2a5077717157ea6a1528292761c7d20e7ec53bd0f28bda"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    libexec.install Dir["*"]

    cd libexec/"src" do
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    bin.install_symlink Dir[libexec/"bin/go*"]

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
    # Remove testdata with binaries for non-native architectures.
    rm_r(libexec/"src/debug/dwarf/testdata")
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