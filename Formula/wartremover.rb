class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://ghproxy.com/https://github.com/wartremover/wartremover/archive/v3.0.13.tar.gz"
  sha256 "b2f301f65151cb47a8f55bb43520a851b7b3699e486f2b1e608959fa2ac5dee4"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd8168b25389746031aaba833de3d597a6865e71529c70a07002870634c9e170"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar", "core/assembly"
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