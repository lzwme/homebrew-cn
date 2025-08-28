class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.299",
      revision: "b171682b8f170a5de2942e47b60fa8113cfe5e87"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0021402b03f004cada888a507e322be7fcfecef89e433b26c33b439e15d6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0021402b03f004cada888a507e322be7fcfecef89e433b26c33b439e15d6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0021402b03f004cada888a507e322be7fcfecef89e433b26c33b439e15d6fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ad3a20c1baf526be2ed9fa82c26d9709016d2bdbe3ad2b0f0db17c62a9e088"
    sha256 cellar: :any_skip_relocation, ventura:       "d4ad3a20c1baf526be2ed9fa82c26d9709016d2bdbe3ad2b0f0db17c62a9e088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989bea15238447bbc7335b61adfbfccebfd802973ca57c4f1351bd251525e8bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end