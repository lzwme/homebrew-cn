class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.195",
      revision: "8d44cf797357a2c0645f48358fce8d5fb3c46937"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73885214676c1add3dec388dff8af1a327f3237349973c10d0026405ea0c5a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e8f58489f438c8efbec1a73003254d374368388b77c3defa0c9d4caf743116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd08564f1a63c44b13f5b246a984d6bac67a4e3cb2cd768326a5b6318829b0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5b1c81740a14687dcd9171ca41ec914d740211d8bc4cac316f2395b8cb8dcc7"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ad5c3b7d619d8340fb2a7ed7f9f0911d50a7ea66cf346e2438d7869829bf72"
    sha256 cellar: :any_skip_relocation, monterey:       "0bea3ce7651d4de31744418d415989d4649b45e1ba7b44a667aa7d7d663ce634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808267845bec3a59ba205ee5d683e583439afd0581836e30d347023a16e93f87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags: ldflags), "mainmain.go"
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