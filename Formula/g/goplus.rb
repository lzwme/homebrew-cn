class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.0.tar.gz"
  sha256 "d22d4921c0bdc60670aaaf3ea24eae3d3a96580feafb4d75494ef02364ef7480"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "76f1b7b8d6cc34ba775b106379ecdb65ee7fdc94878f6f30e18d181a9e23c250"
    sha256 arm64_sonoma:  "e81fbff5e3e2f33a0f46be150f698a3df0b14ff2af368dfc391bf4a6cc8f056f"
    sha256 arm64_ventura: "aad668ffacbc638799fd033bc878c2bed58616ea09de16e6729c7830f91a7486"
    sha256 sonoma:        "a5079ee517ab121a86178807ec2ca4ca8e950b9cffd15b7584913c81ed329a89"
    sha256 ventura:       "71b16318d966f133370172a5b73b313a7ac9990ff372ac4cf6564e251706f32e"
    sha256 x86_64_linux:  "45caf71df22bb3e3574dceb1fb7dafc6b1085c456e4b64348643d8a78a6ed57b"
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