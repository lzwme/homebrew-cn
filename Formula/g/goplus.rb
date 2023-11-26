class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://ghproxy.com/https://github.com/goplus/gop/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "49a6461b3a49f07da1bce9f47a6ec228daadca7a89785695b1db457211346b1d"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "151d447ca74f63ae2deb6f8e0261ff739466a25388e660b3a25376f0ccd11df3"
    sha256 arm64_ventura:  "dca84478384f39201c8f12249f671478d95123a83fa46531ba16252c29b74ca6"
    sha256 arm64_monterey: "1f0e7efb044d70343f1e6d6502afbc3ee25a1a18df90f2e8552dc58ce29ae843"
    sha256 sonoma:         "ac06e358097d29e432e0b54b6b076de3cef0152478462ad4a0a787ef079a392c"
    sha256 ventura:        "7986807ffc96fceaf0956c314cf2865d22e2060420922f82b6d207cb5d48bb60"
    sha256 monterey:       "f85e5a323600843800952cbe50b605c7be57afb0b49d47b87b1bdfe4319cf169"
    sha256 x86_64_linux:   "98ac7d095b0f30875ad1e0bdc3bcf496b7a9024c0dc5b6be83c6a00e36be9fa2"
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