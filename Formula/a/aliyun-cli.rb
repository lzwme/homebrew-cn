class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.282",
      revision: "0dd2ea5d47a37e6752fc51f15cf7ac0dd6646eeb"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047a56affcea4d8a248f46ba754e60d1c28541fba0908870b65f9ae7cc1a5ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047a56affcea4d8a248f46ba754e60d1c28541fba0908870b65f9ae7cc1a5ba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "047a56affcea4d8a248f46ba754e60d1c28541fba0908870b65f9ae7cc1a5ba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "80aaf62c2e918dc055b9f97e31defad1cd012f8cf18f4d2bcc7c87ca1d229195"
    sha256 cellar: :any_skip_relocation, ventura:       "80aaf62c2e918dc055b9f97e31defad1cd012f8cf18f4d2bcc7c87ca1d229195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9d0b1e256d5c7b36e2a06292c35e5e39d8cca7222556fe5c44c6c0d961a4ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
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