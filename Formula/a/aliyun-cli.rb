class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.20",
      revision: "bad29b5826f1776929cbd201126a39aa65bfb3d2"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c38b6cad025aeff68db2cdaa07da59a85fe5f094c8ab0478431be70995dc8d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c38b6cad025aeff68db2cdaa07da59a85fe5f094c8ab0478431be70995dc8d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c38b6cad025aeff68db2cdaa07da59a85fe5f094c8ab0478431be70995dc8d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3480b3ac7543b5cceb28ea74cd4119bb903c79ba4eaa79a8ceabe1b2a7796f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94bdc6111b96168593f9a05c3f80dbf39eac490c1f8c1d0da5f8eb57b7996f6"
    sha256 cellar: :any,                 x86_64_linux:  "b521497c329d98bcfc98a96581c2370a3539fc0ce2fed4297fb30964472e0b5d"
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