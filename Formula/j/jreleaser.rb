class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https:jreleaser.org"
  url "https:github.comjreleaserjreleaserreleasesdownloadv1.13.1jreleaser-1.13.1.zip"
  sha256 "c384888b61fd99ba3a3d3366a20ca5bb63e6ec054eb2841490ede5762d87ae59"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5ec5cb286f23baab835fe8d934b7aa74c289b27daeebe7366e8ba1a6a3677bed"
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