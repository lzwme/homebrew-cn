class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.4.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.4.src.tar.gz"
  sha256 "47b26a83d2b65a3c1c1bcace273b69bee49a7a7b5168a7604ded3d26a37bd787"
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
    sha256 arm64_sonoma:   "e3b1b54314a26125d0dc830958acd92f496b0dbbbc2715432625c3654ae755fc"
    sha256 arm64_ventura:  "4ebad2bef4071b548abd25159e6348955bdd0663b1fe4bcfa73dddc6dc81ae70"
    sha256 arm64_monterey: "31cd113ca708acbf5511ccf7e8601a71fe93d8dc5eebe33efeff2a208dc6202b"
    sha256 sonoma:         "3a1f3f415368cf9889ae5aaa86d27db81085e1ef34b1a4be962d5d2898e63322"
    sha256 ventura:        "edb5918b8620b11184629c6a4b538d883406fe371a92a41c5005a305ea284b9c"
    sha256 monterey:       "7b649da4603c099cb2e09b37e25f0fcf57c7fe6979dcd5788d9a53bd7aca419a"
    sha256 x86_64_linux:   "b097f702561988ac5f8f9529dc206e50c8c916823b548ebbc979cc89a50365a9"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "e4ccc9c082d91eaa0b866078b591fc97d24b91495f12deb3dd2d8eda4e55a6ea",
      "darwin-amd64" => "c101beaa232e0f448fab692dc036cd6b4677091ff89c4889cc8754b1b29c6608",
      "linux-arm64"  => "914daad3f011cc2014dea799bb7490442677e4ad6de0b2ac3ded6cee7e3f493d",
      "linux-amd64"  => "4cdd2bc664724dc7db94ad51b503512c5ae7220951cac568120f64f8e94399fc",
    }

    version "1.17.13"

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
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "std", "cmd"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
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