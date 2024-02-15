class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.2.1.tar.gz"
  sha256 "d5f424d2278e0e021f5c322431766834aa5acfa7629f67a42f035e29f2c080f3"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "e652da08fabd1a7573977eb486dc11b8002ad618fe6fc6fc63ec56743af664fe"
    sha256 arm64_ventura:  "d633e51773d20d7c13a8bb87a7133d77fdd66028149aaba7b2cbb5e34d0904da"
    sha256 arm64_monterey: "3e630d1e5542ac68dcd0cce15a70f992f5d9eb707b02c656be7ef6f35238a6c8"
    sha256 sonoma:         "f0fc165b961d521c0ffe547b3d29dffc421886f6534b0ed660c4c5850ed93438"
    sha256 ventura:        "d91f9118168d219d2c7c0c1087fcaba231a1083cf8da88b73e928879caaa232a"
    sha256 monterey:       "eebae1e08822124d625134702f0f9e37fafbcbec020f8520273e06948cccdc28"
    sha256 x86_64_linux:   "33e962651d26de147dee60213e722f76486028dde07378ca0af91e77170c99fc"
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