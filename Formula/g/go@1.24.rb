class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.11.src.tar.gz"
  sha256 "ffdf97766a4c4b135cd53809713978e9ee1a943b2c8e28ad221a5429de30e210"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015118cf40fea9fda481f8a3fb2b0a9993e4c9ab5384bd28164730f7dbb04a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "015118cf40fea9fda481f8a3fb2b0a9993e4c9ab5384bd28164730f7dbb04a51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "015118cf40fea9fda481f8a3fb2b0a9993e4c9ab5384bd28164730f7dbb04a51"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec19a7aee9048e68358bc52c4998cfc6e28e50b8d27780ff3f0d10cfedfc49d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8112bee8dece9b9a1040212126579e5b1fd48276188bc262e69b4aa2379a0b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61b24360bf1e42a8f5ab284309b81777cdc560426f8e41e5c944ef4e7b11916"
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
    with_env(CC: nil, CXX: nil, CGO_ENABLED: "1") do
      assert_equal "Hello from cgo!\n", shell_output("#{bin}/go run hello_cgo.go")
    end
  end
end