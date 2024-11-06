class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.228",
      revision: "17fb480de14d92e54bc3d8c84b8c57c80ceed0bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b951d181331e47ec1e1c2fa5afa5d036f33a1de8269ceb52f7a0644546565f23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b951d181331e47ec1e1c2fa5afa5d036f33a1de8269ceb52f7a0644546565f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b951d181331e47ec1e1c2fa5afa5d036f33a1de8269ceb52f7a0644546565f23"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c0ce039421c8d9792a3de3d9918a73817cf5cc11efccbfb4b53e4139e6c4d4"
    sha256 cellar: :any_skip_relocation, ventura:       "43c0ce039421c8d9792a3de3d9918a73817cf5cc11efccbfb4b53e4139e6c4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89da7003cccefb65a2125ab470736770e7043bd85eafceba35c3d848829f0622"
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