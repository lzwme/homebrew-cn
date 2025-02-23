class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.1.tar.gz"
  sha256 "934ec2fac7bc4d2fe313cf194973d5611a75fabd438d62f7f2cf09349658ebc9"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "e719f933d04d9cbd1afee2589ace5b79d84137e63d120b435fc0d2ff08a9d79f"
    sha256 arm64_sonoma:  "248263cd437d585b751b86568c1905aca89efed6585650a89c4598611f4e8ce9"
    sha256 arm64_ventura: "4b81414bc67141666dd395b3b82d305e7c15f2edae16f36a42e6de6606d8f42e"
    sha256 sonoma:        "8a1187254de324e6068c5e99683dfaaa8bbc9969c4fca5b5ebf880e5b359fcf1"
    sha256 ventura:       "541eeb569c11afebeb7d1c34c258021d39df4f62c6b4ce487bc3aeb214b417c6"
    sha256 x86_64_linux:  "da249375937530ca93d12e1a8e86efdb2da0754e32a767ea5aaa0bac3288650e"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmdmake.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    (testpath"hello.gop").write <<~GOP
      println("Hello World")
    GOP

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}gop env GOPVERSION").chomp
    system bin"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}gop run hello.gop 2>&1")

    (testpath"go.mod").write <<~GOMOD
      module hello
    GOMOD

    system "go", "get", "github.comgoplusgopbuiltin"
    system bin"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output(".hello 2>&1")
  end
end