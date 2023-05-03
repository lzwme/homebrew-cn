class GoAT119 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.19.9.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.19.9.src.tar.gz"
  sha256 "131190a4697a70c5b1d232df5d3f55a3f9ec0e78e40516196ffb3f09ae6a5744"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.19(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7fc9b08acd36abd58aedac821c8efe2b591553e5207833a9157444e143b0dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf4ed14ae0d95fc3063a2b5cf1c65a25ae8b7ce8354ab66e51ac7a55065c892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e60e991ae8fca847eb64561ca27b491b60f3de152c8071c0fd72f8f82ce5073"
    sha256 cellar: :any_skip_relocation, ventura:        "1512f5ecf9acad94c66c5d76d8af694761861774c268f3f0fbb1908f9d923ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "2918bb5fc27e290eb03e7f633351e8a03974bff6bfdf8de795a0c626e863fb66"
    sha256 cellar: :any_skip_relocation, big_sur:        "45110d1f92b708dd9b78152ed2614db1b6db277ba015a9689d87532d9ecd441d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e86eaad398f1af2ecae6f8c2218905962a4911af795fe35968cbd26b37d54d"
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