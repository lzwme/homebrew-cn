class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://ghfast.top/https://github.com/wartremover/wartremover/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "940ef740e76954d19d7dc244c8e88560719849b649815b04de12138e986d2921"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78b50cc81706773e0e270f875ab9dffc5fb4ce33d6961f6e963db1029ff4d370"
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