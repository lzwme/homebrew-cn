class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://ghfast.top/https://github.com/wartremover/wartremover/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "6ac0941ca3858a4ff2e6ae3caa897d50447b122c7686c9767665b6bae9cd1cee"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94e2ad7703a3fc2217bb653d0d0ebf68d23cb3b63ed36d5eb94b5df473e6352f"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end