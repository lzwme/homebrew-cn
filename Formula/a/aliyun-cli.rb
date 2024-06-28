class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.210",
      revision: "448b5533c49ab223c9087ff62c816b05b2ec2c43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48c32d5f77bb800e36377fcac9cfd267f96b49304d7198f1616ada990efa1092"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd648264613963ad141455049753d86e3b463328da5242db536ccc562a4a3f12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29225469ccd5e7a2581ef6cc97a93b336fbfd75b0198a49cb5cc1b8e32f21ac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce52d3b50829e88d90b10fe50ce536ed136e5e4aeb3afb4e4ea8592595d531f8"
    sha256 cellar: :any_skip_relocation, ventura:        "c37603e3744fe52c0ebf60b67b6952d699ef94dfc29b5af2bd65f77621a5e1df"
    sha256 cellar: :any_skip_relocation, monterey:       "2e73ffc8e4af26b5034a1625cee34bcb627f6d63adb5da44cf126758477f72f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56dcbf3376535a7ea2254d8053495698974e41b5e4ced231d402a8c4e7cd91b"
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