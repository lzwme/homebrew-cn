class GoAT121 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.21.12.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.21.12.src.tar.gz"
  sha256 "30e68af27bc1f1df231e3ab74f3d17d3b8d52a089c79bcaab573b4f1b807ed4f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.21(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265e7c4cfbf3125f6f5706704e8c938ba128dd28255612373cfaa35c9b013f64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace2de82bd7cb9d560e8755e77069bf5c1407f60d9bf4e89bf0bf0338c680812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf031207bb62eca1551e988c0cf1fd39a57d091dfe3bc99d7b16cb736479b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4121b05ae63662ebd68a2807b3c7ea3f2363bf57e5bc55c8a46899a764c883b"
    sha256 cellar: :any_skip_relocation, ventura:        "c6bf23c32bb6f49fbcaa8c16370b1f9f9030d614146d2a3717b0c6c709fb04dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b928171e4088bdb69f02d3fe31a617371662180436f8fd5cce396b228befe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebd9bce0e579e91419ce92b8793b7de8d76616e4448d8dd2343fc3162df4332"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      # Set portable defaults for CC/CXX to be used by cgo
      with_env(CC: "cc", CXX: "c++") { system "./make.bash" }
    end

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