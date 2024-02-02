class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.2.0.tar.gz"
  sha256 "6fa0a03fdc554b3954f2ac0c89109ddfd25ba1ec062b048c4b6386d9e9350d7b"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "d795817f955a41f88964dd79b09ac40dd9c7407a580fb87adb2e47fbe4e3579b"
    sha256 arm64_ventura:  "2049b25698a4dbcaf490b1b682b4bdbaa7acccfb85fc99bf1f5c1c1428b17130"
    sha256 arm64_monterey: "0987bbb82099d2c82f70f7531372a280b4d7161f08b1a03a27f66527f10496a5"
    sha256 sonoma:         "948a98ca6656bc4896069810826f47c47690407068f88f8f62576c51a00b7e59"
    sha256 ventura:        "176010fed4c158090dfc60ee37a65ed57c746a075e71a4c733fde1cd494189d1"
    sha256 monterey:       "c713df2657f4f7b1a61589ab5844c766c3eb6d03defc33f5e55a87bd3e2725f2"
    sha256 x86_64_linux:   "07e66ebe99b958d803158837e947dd33ab41264609c7d525c9d031252bd53ced"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmdmake.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    (testpath"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}gop env GOPVERSION").chomp unless head?
    system bin"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}gop run hello.gop")

    (testpath"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.comgoplusgopbuiltin"
    system bin"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output(".hello")
  end
end