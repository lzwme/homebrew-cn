class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://docs.structurizr.com/cli"
  url "https://ghfast.top/https://github.com/structurizr/cli/releases/download/v2025.10.29/structurizr-cli.zip"
  sha256 "cbfab2ca6b4d51303f528f831890118f6d241ad6a196d2215b8f6de7848f7663"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3234e99aad04ff84d8881324038a182af32496c2f60bc3ca767a6e5b54c81012"
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