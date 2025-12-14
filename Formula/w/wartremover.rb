class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://ghfast.top/https://github.com/wartremover/wartremover/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "5c3c68d03a5542a200bbc860444c484dce16548c189a26c93313c297861a50ce"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f3515ce9fdb557ca77605f336f7aa5575422d431f28cc96cabbe1b16d105114"
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