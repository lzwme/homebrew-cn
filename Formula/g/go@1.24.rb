class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.9.src.tar.gz"
  sha256 "c72f81ba54fe00efe7f3e7499d400979246881b13b775e9a9bb85541c11be695"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89c525cb13bf69ab14cbeaed77cda1fbc462d74e903508ea796ed8d096b681b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89c525cb13bf69ab14cbeaed77cda1fbc462d74e903508ea796ed8d096b681b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c525cb13bf69ab14cbeaed77cda1fbc462d74e903508ea796ed8d096b681b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce909b993298f900ec47f23ea1e86a2370d78232cefe204c1aec17228feb04ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1c225cc1a5affbb7d9ccd2d0ad51bf55a8b7319cbb08413e522075317329efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23ca7abdddf1801523689bcb0791ff2b5001607e069f9c3b32e62baccc5105a"
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