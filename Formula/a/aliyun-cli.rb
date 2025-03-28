class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.264",
      revision: "5290d318eeb48d510ef3a2970408f51cbfa6e8d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a758e567cca10d6a40f45f98cd7b108caadf062ee390b25d434ff5132bad0a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a758e567cca10d6a40f45f98cd7b108caadf062ee390b25d434ff5132bad0a6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a758e567cca10d6a40f45f98cd7b108caadf062ee390b25d434ff5132bad0a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd70853eb9de62401cde7361a6ffa8b43804e5c826bbf1257f8354c435c3c07"
    sha256 cellar: :any_skip_relocation, ventura:       "9bd70853eb9de62401cde7361a6ffa8b43804e5c826bbf1257f8354c435c3c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808f74b059370b9e9488439cb5245be8f8996c9d5847d249e5ec93e7e3cf6b34"
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