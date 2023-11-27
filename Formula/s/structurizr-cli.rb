class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://ghproxy.com/https://github.com/structurizr/cli/releases/download/v1.35.0/structurizr-cli-1.35.0.zip"
  sha256 "caa1860d32bcafa792243fd62c0b41d6891fe20a9b7f35f1e7c3405dfb7554f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cb11b6e1eb0a965cc93207309bc0db8b47c709317519765d10522cfb664b41b"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|version|help [options]", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end