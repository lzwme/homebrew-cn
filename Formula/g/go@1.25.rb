class GoAT125 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.13.src.tar.gz"
  sha256 "1d7e2f70b1ee9b93c7df8efcca71f5adcc6a59797a4336c2d10171bd4c174614"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.25(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824d2781aafdae206085847deeea75413cc1bf0b321bbfd58108961a58ac7b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824d2781aafdae206085847deeea75413cc1bf0b321bbfd58108961a58ac7b33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824d2781aafdae206085847deeea75413cc1bf0b321bbfd58108961a58ac7b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c746697603baa73140d7032d314c3ba30defe97bbf7428754a484e298547050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4151f8de84aecc97eb8cfe2760eb1a990c6431997bda2bcf34fefff175cc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd18a349b0d9841c6157e3456f5133969257e9cb64a1b965284328af1d3fb846"
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