class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://ghproxy.com/https://github.com/structurizr/cli/releases/download/v1.33.0/structurizr-cli-1.33.0.zip"
  sha256 "d93cac99abae872bd398a786e97e328ac4491952091a4a8e1d20b2e5067253f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, ventura:        "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, monterey:       "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3bb827ea0c050176d9907067de5a9b4c9228ae83d8b2e77abbf4579ddf7b640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d5bb5037a6fc115090fbb7ceab208a2ac2c2200f2ef774dbcf5eb99bc51482"
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