class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://ghproxy.com/https://github.com/structurizr/cli/releases/download/v1.31.1/structurizr-cli-1.31.1.zip"
  sha256 "3a2f60693ab0c91fab943d49d7c6f66969129aa24448659d19527d4f79067ffa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, monterey:       "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c5fe625762548c5287184a857a6c6dd88391c742039e43aa3ad9f64d9676fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e724c6f830be835a9f725be61f4575a71c2d8ae0c88ed773b5fff098a0caf353"
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