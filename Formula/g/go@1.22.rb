class GoAT122 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.22.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.22.6.src.tar.gz"
  sha256 "9e48d99d519882579917d8189c17e98c373ce25abaebb98772e2927088992a51"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0cc04452dd7ce43d0a727c12cae2bf44ac7c0403eeebf2325392b130d1548cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee649c739b83c75317c3bb881c54ccfaa0e8f86052a626b0cc8ffff417cf5b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4f0af48a5743a318d85cfc384beb1280337394fb3c5599c326091290b481f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaee6d93d2df2311072eb5e709d12fcb598f2fdd54939eb935922210eec9f2f8"
    sha256 cellar: :any_skip_relocation, ventura:        "9d85b2339ebdcbadc3b5de8f9560b9aa9621802f7cfed1166ea89fe9eb3546e8"
    sha256 cellar: :any_skip_relocation, monterey:       "26767eb8e50f2888f563906d89321b3f1947127e869d4d72fddf3a364a733604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4670590a4a63ce97f5277a097146bbb45817d943d8dce6ffc080918044717f91"
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