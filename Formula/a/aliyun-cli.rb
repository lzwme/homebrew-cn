class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.225",
      revision: "c2c29d6addb1322e00a7dac19c2ce84706bc7819"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2cb2747167f3ee7fe8a18cde5825266e6d2da09fe969cbcd5acdd36f78e88fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cb2747167f3ee7fe8a18cde5825266e6d2da09fe969cbcd5acdd36f78e88fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2cb2747167f3ee7fe8a18cde5825266e6d2da09fe969cbcd5acdd36f78e88fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "72162598f1c15d202c5e8c669e75614dc08dc47b00369c6ebe6468461efd2611"
    sha256 cellar: :any_skip_relocation, ventura:       "72162598f1c15d202c5e8c669e75614dc08dc47b00369c6ebe6468461efd2611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669b1e2ce927a1251bbc5e910978d471b10854e21c837a482779f3f950d00868"
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