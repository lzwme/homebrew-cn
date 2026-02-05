class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.13.src.tar.gz"
  sha256 "639a6204c2486b137df1eb6e78ee3ed038f9877d0e4b5a465e796a2153f858d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2f5e66c177e5c2efd0d83e9fceabb8191163518d94d93caabfa0b8e700f9154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f5e66c177e5c2efd0d83e9fceabb8191163518d94d93caabfa0b8e700f9154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f5e66c177e5c2efd0d83e9fceabb8191163518d94d93caabfa0b8e700f9154"
    sha256 cellar: :any_skip_relocation, sonoma:        "892c108c02ebddd0fabe372dd172334a2ab35e4523f6d5c96ce4347e8ac03d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7d330f1c8a92f0fbf768b83af03a476b92ed929d011ba1db4ef78cca698b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c59e725d0c7d7c5ab05ab81575c084dceb3cd22078baa3984b27f85af428894"
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