class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://ghproxy.com/https://github.com/structurizr/cli/releases/download/v1.32.1/structurizr-cli-1.32.1.zip"
  sha256 "94532284f70d1ecf2b46a91123371f12fb4c8fd60535070f1e28843395b7a2be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, ventura:        "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3ff5dd57c5389ea71a91d7e1701b7f9c5e19ca7192ed1c80cae6908b4acd9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99d1a07207001d20ed1e1671b0f51d20811fc1e0853b4546c3b560fb82f033b9"
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