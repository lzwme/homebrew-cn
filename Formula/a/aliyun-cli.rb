class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.4",
      revision: "0e858e37357369cf71e2635cda3ec617601d4be0"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0530e25013f266366eea471f55f49ee90792fa471bd440a43a2f8d484140a3ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0530e25013f266366eea471f55f49ee90792fa471bd440a43a2f8d484140a3ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0530e25013f266366eea471f55f49ee90792fa471bd440a43a2f8d484140a3ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "216160310855734f6a6346343c66711e0eb29393b940a285263fb7d5d381c453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa55247e1f15462077c60ea09ee94f1c7a890a2e147e99edea9edc97eaccad11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8cc8146792833e91d359970931336c59148a35cbfda25c2773abc42e52f722"
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