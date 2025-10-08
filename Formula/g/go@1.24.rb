class GoAT124 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.24.8.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.24.8.src.tar.gz"
  sha256 "b1ff32c5c4a50ddfa1a1cb78b60dd5a362aeb2184bb78f008b425b62095755fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46aab06912425dc499f9b4376d7c464dfd1bfaa65cd05ac77e2bb0d780abea76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46aab06912425dc499f9b4376d7c464dfd1bfaa65cd05ac77e2bb0d780abea76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46aab06912425dc499f9b4376d7c464dfd1bfaa65cd05ac77e2bb0d780abea76"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bfd0ccba107c7a48546058aaa6c9f78fe5d85e23f53c91faf78314744e7a966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288648becf05c70f322d1780de2c96c48c507626f9b9827c49d42205ea4f491a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2236048913f56eceaefcff1cb2675b316008d5ff1036a95c7cea19d25e851499"
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