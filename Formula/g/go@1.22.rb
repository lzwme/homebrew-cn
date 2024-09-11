class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.7.src.tar.gz"
  sha256 "66432d87d85e0cfac3edffe637d5930fc4ddf5793313fe11e4a0f333023c879f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/?mode=json"
    regex(/^go[._-]?v?(1\.22(?:\.\d+)*)[._-]src\.t.+$/i)
    strategy :json do |json, regex|
      json.map do |release|
        next if release["stable"] != true
        next if release["files"].none? { |file| file["filename"].match?(regex) }

        release["version"][/(\d+(?:\.\d+)+)/, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "435f6ae9eeaa801606f8bce0ad94257526e9d9e16a1bfed968bd5d0570a4acc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e815b924a1a0c4e020660a05fd4fc8defe0e83a340007e5e52edb184bdcabdc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c1ccc2d88b298b3cc1c844b408684d7d4fba4a8d9c6e25bc1280566ad46bab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9535b80342f84a7dc6202bbd9789886edd1bd35f21757995a9bb404734601120"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d05455fd385f2677ed451969b1cf2ceca5a8654045473f61e26a88637722407"
    sha256 cellar: :any_skip_relocation, ventura:        "bfa9ba4c62d9508da52b41acc031bfb0188da9452a9cc9e882f12300ccdd4a36"
    sha256 cellar: :any_skip_relocation, monterey:       "60a5948e8f15e97bbb1071f827054bf587f1dd03ac13b720a7445ceea9162928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3f954ce1267c53c0cf751f5d12a8f99d7e784f993f9b083aed3c9bdf582151"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    inreplace "go.env", /^GOTOOLCHAIN=.*$/, "GOTOOLCHAIN=local"

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