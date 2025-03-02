class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.5.tar.gz"
  sha256 "3534daa7e530af7b96001f489c1026757590e2d8b43c483633635101ef982b8c"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "70d4814e1abc891b2f45ae0eb181ce378f69d74b0dd9e79153c96bacf9da8f79"
    sha256 arm64_sonoma:  "a1a6c7e825903a396d6381d8e03b7c251b5e1e94d71be019ce2b70c4b9383263"
    sha256 arm64_ventura: "5714291116ba39ad1cc884ea7a1f1749d0acca6df6a1d9a1b99d04bd3220f035"
    sha256 sonoma:        "5345c05ece1a1cf65e3b833e536bbb81872a5ed60ad0e08e07256512f70734bc"
    sha256 ventura:       "641516cdc902dedaa625c7cafb04fe6a94a1396b9707171efcc0c36e8da4703f"
    sha256 x86_64_linux:  "2d892d6bce2cc174e8efa0e77623d57eae04e45122d95b0980188cd34b5c76fb"
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