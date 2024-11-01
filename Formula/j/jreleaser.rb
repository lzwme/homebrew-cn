class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https:jreleaser.org"
  url "https:github.comjreleaserjreleaserreleasesdownloadv1.15.0jreleaser-1.15.0.zip"
  sha256 "fd3d5b424190956313da111c144bb4788fc647907722e4a662c1e6654c2ac384"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ad750ca4d977614f20d0cc94bb43e01fda61c5abe41be3f3e658073ced1b66e"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin"jreleaser").write_env_script libexec"binjreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}jreleaser --version")
  end
end