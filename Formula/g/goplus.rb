class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.9.tar.gz"
  sha256 "70e107516b318b472ac24c61caa403c1b5d65a6ca181c8f47ae23769dfd862d0"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "3565bc89279e2e962536aa8b17bbdc977528e046f8b08bf221f533ff2aa4a84f"
    sha256 arm64_sonoma:  "3db5b0bbec1dca9153243d15bf5195fbd4a0b7c3e066f20842ad5e335254e84e"
    sha256 arm64_ventura: "1d824559f7b1a104467c857c8eec524c3c2965e00bbdf64805c2b5e64242dd8e"
    sha256 sonoma:        "45270412586e76de18301e8f0958a1df1034e546c4e1d2164c2d281936e765ab"
    sha256 ventura:       "a275a35e477db3e6830b1f2d01cb599cbb646132b724725d7e103ed7e06ebbce"
    sha256 x86_64_linux:  "a82a0f1fc06ca38fe1636ed46a905d97fbb35cb66e87aba39eb8dc5baf5b802d"
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