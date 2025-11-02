class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://ghfast.top/https://github.com/structurizr/cli/releases/download/v2025.11.01/structurizr-cli.zip"
  sha256 "2fa5dac05d2168ae61de68ba9204d3d7c879aa7e023d50703f400f99817ce432"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "938878466fa836f73be197fadfd62f7feade271af079f342d2cb162813c6642b"
  end

  depends_on "openjdk"

  def install
    rm(Dir["*.bat"])
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = shell_output("#{bin}/structurizr-cli validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end