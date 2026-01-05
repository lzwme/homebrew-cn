class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.5",
      revision: "6818a5b00cbc1274a4d0402b2a0385b6ef9eb3c8"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b91ea5eea04c7867a8200a5a2e90174b832c43070e98f50078c00236ee9f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b91ea5eea04c7867a8200a5a2e90174b832c43070e98f50078c00236ee9f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b91ea5eea04c7867a8200a5a2e90174b832c43070e98f50078c00236ee9f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a8cc9686adecf155459cf441b9f3fadbacb139bfcdddd49b5032fde61a7944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "909f60e6f1084d7436b03af7619ff8f45ae312d9dfec24ed550137cac648c23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b411b52eec8546e808551755e3370000160db9828c34b7b096136b37267baf5a"
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