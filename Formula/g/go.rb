class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.23.0.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.23.0.src.tar.gz"
  sha256 "42b7a8e80d805daa03022ed3fde4321d4c3bf2c990a144165d01eeecd6f699c6"
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
    rebuild 1
    sha256 arm64_sonoma:   "5cc408349e666ae1c8ee789d057990f523a0cb8cc51919a913eb0df64e410d43"
    sha256 arm64_ventura:  "5cc408349e666ae1c8ee789d057990f523a0cb8cc51919a913eb0df64e410d43"
    sha256 arm64_monterey: "5cc408349e666ae1c8ee789d057990f523a0cb8cc51919a913eb0df64e410d43"
    sha256 sonoma:         "68252d4fc1abb13c66c9ee088c1f97628beecac65b6c1223cf72dd517adab1b1"
    sha256 ventura:        "68252d4fc1abb13c66c9ee088c1f97628beecac65b6c1223cf72dd517adab1b1"
    sha256 monterey:       "68252d4fc1abb13c66c9ee088c1f97628beecac65b6c1223cf72dd517adab1b1"
    sha256 x86_64_linux:   "8dc5e2fbbb380bd1b1f41b2be7bd1faa61b8d071231d4b193a23f1e6353f28ef"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "6da3f76164b215053daf730a9b8f1d673dbbaa4c61031374a6744b75cb728641",
      "darwin-amd64" => "754363489e2244e72cb49b4ec6ddfd6a2c60b0700f8c4876e11befb1913b11c5",
      "linux-arm64"  => "2096507509a98782850d1f0669786c09727053e9fe3c92b03c0d96f48700282b",
      "linux-amd64"  => "ff445e48af27f93f66bd949ae060d97991c83e11289009d311f25426258f9c44",
    }

    version "1.20.14"

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
    inreplace "go.env", /^GOTOOLCHAIN=.*$/, "GOTOOLCHAIN=local"

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    rm_r("gobootstrap") # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    rm_r(libexec/"src/debug/elf/testdata")
    # Binaries built for an incompatible architecture
    rm_r(libexec/"src/runtime/pprof/testdata")
  end

  def caveats
    <<~EOS
      Homebrew's Go toolchain is configured with
        GOTOOLCHAIN=local
      per Homebrew policy on tools that update themselves.
    EOS
  end

  test do
    assert_equal "local", shell_output("#{bin}/go env GOTOOLCHAIN").strip

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