class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.25.0.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.25.0.src.tar.gz"
  sha256 "4bd01e91297207bfa450ea40d4d5a93b1b531a5e438473b2a06e18e077227225"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/go.git", branch: "master"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(\d+(?:\.\d+)+)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c0a694a5388db003329d7f6d5069249117e89484fec919316808403d701815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c0a694a5388db003329d7f6d5069249117e89484fec919316808403d701815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34c0a694a5388db003329d7f6d5069249117e89484fec919316808403d701815"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cc57e2a94be4bee8a2971b0269191ba81f079e3aa356e325902a9e36a08da3f"
    sha256 cellar: :any_skip_relocation, ventura:       "1cc57e2a94be4bee8a2971b0269191ba81f079e3aa356e325902a9e36a08da3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1082220492dd5dbd8ba62df6e694f0e15174f9c93783d84db2018555c6d0771f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01574eeb30d53c35d5bec9ef2c8fe3d7f14db16835e25353fa371bd11ac11c3c"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "416c35218edb9d20990b5d8fc87be655d8b39926f15524ea35c66ee70273050d",
      "darwin-amd64" => "e7bbe07e96f0bd3df04225090fe1e7852ed33af37c43a23e16edbbb3b90a5b7c",
      "linux-arm64"  => "fd017e647ec28525e86ae8203236e0653242722a7436929b1f775744e26278e7",
      "linux-amd64"  => "4fa4f869b0f7fc6bb1eb2660e74657fbf04cdd290b5aef905585c86051b34d43",
    }

    version "1.22.12"

    on_arm do
      on_macos do
        url "https://storage.googleapis.com/golang/go#{version}.darwin-arm64.tar.gz"
        sha256 checksums["darwin-arm64"]
      end
      on_linux do
        url "https://storage.googleapis.com/golang/go#{version}.linux-arm64.tar.gz"
        sha256 checksums["linux-arm64"]
      end
    end
    on_intel do
      on_macos do
        url "https://storage.googleapis.com/golang/go#{version}.darwin-amd64.tar.gz"
        sha256 checksums["darwin-amd64"]
      end
      on_linux do
        url "https://storage.googleapis.com/golang/go#{version}.linux-amd64.tar.gz"
        sha256 checksums["linux-amd64"]
      end
    end
  end

  def install
    libexec.install Dir["*"]
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

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