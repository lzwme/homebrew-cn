class GoAT123 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.10.src.tar.gz"
  sha256 "800a7ae1bff179a227b653a2f644517c800443b8b4abf3273af5e1cb7113de59"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea733b8992ef75e11e70133d5b29d21024ae1eb9de0f1de62537c98ad49fef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ea733b8992ef75e11e70133d5b29d21024ae1eb9de0f1de62537c98ad49fef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ea733b8992ef75e11e70133d5b29d21024ae1eb9de0f1de62537c98ad49fef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "11dbfe0a1f11d431e0fbe96da497382aae33b4dccc9245266b403608cc298970"
    sha256 cellar: :any_skip_relocation, ventura:       "11dbfe0a1f11d431e0fbe96da497382aae33b4dccc9245266b403608cc298970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239bb0e2c34de2c54fc206cded4a2ce578d867df731af3026d764222ecc43fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a5e598fd23a409d39c7c91ee24b109f5c76611b074e7e941cfe58b50e0d030"
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