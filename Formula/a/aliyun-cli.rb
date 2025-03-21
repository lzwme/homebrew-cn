class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.260",
      revision: "adc4b23f7ed9aa020a545a2e8b8b4038716dcd14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820cad891ae414bca725d1d7b7339dc92c82896869dbe0d3873dcf2cd06ad9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "820cad891ae414bca725d1d7b7339dc92c82896869dbe0d3873dcf2cd06ad9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "820cad891ae414bca725d1d7b7339dc92c82896869dbe0d3873dcf2cd06ad9d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b87c9c5095d573a87411fc4118c60606d5aa0e624d31383b6548451cf488268"
    sha256 cellar: :any_skip_relocation, ventura:       "6b87c9c5095d573a87411fc4118c60606d5aa0e624d31383b6548451cf488268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985b11eb328d5e5e17d8ec3ab4ee8d60d063eab18d72adf9210992de71458b7f"
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