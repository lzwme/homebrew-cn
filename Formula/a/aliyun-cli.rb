class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.231",
      revision: "4e3de3a50523e0b0eecba2eff93156c0226048c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eefb39f8e64c2025d30c8ae2a27f1f9caa5cd8c893993e73fb52134aa7c9783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eefb39f8e64c2025d30c8ae2a27f1f9caa5cd8c893993e73fb52134aa7c9783"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eefb39f8e64c2025d30c8ae2a27f1f9caa5cd8c893993e73fb52134aa7c9783"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9282f08d26f32e2bc8006206cc345ecddd5d3f391445f67b63ab91be6490545"
    sha256 cellar: :any_skip_relocation, ventura:       "f9282f08d26f32e2bc8006206cc345ecddd5d3f391445f67b63ab91be6490545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d15faebfc197743775ab5b3c95957e24a7de75776d53f3d1490b942624c78b2"
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