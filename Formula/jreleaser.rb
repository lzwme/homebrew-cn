class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://ghproxy.com/https://github.com/jreleaser/jreleaser/releases/download/v1.5.0/jreleaser-1.5.0.zip"
  sha256 "baa07cd0c840bf24f554f564f70372ef81189956141b6ac432a507ff1f05c783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "266426b360aea342cda76cadb5bb5aa23d38933938b44a1c066101dc497c6736"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end