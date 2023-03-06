class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://ghproxy.com/https://github.com/structurizr/cli/releases/download/v1.28.0/structurizr-cli-1.28.0.zip"
  sha256 "375916e54dffe785318f9c57e20a35c5f06ebddb10bbf9ee4197bebf5edd3d36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68bc16162ac126b17e2c6e83437613dee092dd38a76f26d7e8e4cee09743ec7c"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "structurizr-cli: #{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|help [options]", result
  end
end