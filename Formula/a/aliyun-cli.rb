class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.265",
      revision: "47e0317d938638b1235499365c188bacfb3c96d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983f514e575f87bce7a378a89db35d16c62ee5f74d999e6166f706bea95495bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983f514e575f87bce7a378a89db35d16c62ee5f74d999e6166f706bea95495bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "983f514e575f87bce7a378a89db35d16c62ee5f74d999e6166f706bea95495bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3193b4e6a3c5fc41f3f88585b7f6bc4f62fe4f934d6baf153077c56797b9d986"
    sha256 cellar: :any_skip_relocation, ventura:       "3193b4e6a3c5fc41f3f88585b7f6bc4f62fe4f934d6baf153077c56797b9d986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0739e4b12a8b64f04a6ac4ec69eec543c09eee10f2e76f323a251e9c38338c69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end