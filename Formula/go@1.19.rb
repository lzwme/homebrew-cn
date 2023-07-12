class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.11.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.11.src.tar.gz"
  sha256 "e25c9ab72d811142b7f41ff6da5165fec2d1be5feec3ef2c66bc0bdecb431489"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f7071ee446c05658ebab2f47600398bb7c433052c2bb750fe54b63a37195667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fec22dd93cae7ad862ad267e093a6c5221417dd2d6e863e7ecab57342ee9147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d635c5d25ec123fc1fd985690891fb564c85b9a20102edd1ade062f6953a89c"
    sha256 cellar: :any_skip_relocation, ventura:        "aff5a945fe05981e02ea50ed4c4babb2d6735f35d649733a369b71ae6225396b"
    sha256 cellar: :any_skip_relocation, monterey:       "60361a6440e772ff6e18ad899d1396c6ca5130b284d1ccdf9c6cbb1af6db8e61"
    sha256 cellar: :any_skip_relocation, big_sur:        "8849a941d7e7b2aa28ce9b775aa7e52ad7c5a8e7bb66748e475c71efc3e13ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0202c32c661efc59feb7cde05544321769f130a18b54a571d5376c40ad57b1"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

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

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end