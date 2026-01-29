class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://ghfast.top/https://github.com/wartremover/wartremover/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "39ccc509834168e499a0843018ba42fe4751d640caa307f6eb7099e94db5ea1d"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "478329f6cfdbffc9fbefe9f08f35acd4a404864d61ea1435fa4f893f6dc63fbb"
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