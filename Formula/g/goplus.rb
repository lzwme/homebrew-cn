class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://ghproxy.com/https://github.com/goplus/gop/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "930c30e3da02f31dca604fa34a34260f172d97b04048dbc5632b0ab471a4ec9e"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "be96008aefd5652b2af9731b01784520be7ea6996c6f8eb81ea054ff16a0fd1e"
    sha256 arm64_ventura:  "7fef21f86e822f62c7ef7a56cdb565343b4a19ad68a92875bc9f14cc1d641612"
    sha256 arm64_monterey: "c6da5d3c35013c0acbd32fedbbb9919dfeed9038783fb05358856460bf0c361d"
    sha256 sonoma:         "d7f9b13cecd1c111b56ee5b194cd3d63938359886d04a77f923be5e17eca111e"
    sha256 ventura:        "b958aa4008d50350c0e82333fed8c0d54ae2a2334bd5704f9e491ffed0085d5e"
    sha256 monterey:       "d3909f0e7ed2d9f3d9901bb4d8198b3c0fcf3929dfaa51b146a0fd8d96a98ffa"
    sha256 x86_64_linux:   "3c94e6d60fd2ae56b252f4a3a028a2152d624d74f40e9d7116966eb43a20c80e"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end