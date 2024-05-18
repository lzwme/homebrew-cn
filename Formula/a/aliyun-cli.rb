class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.206",
      revision: "7508f16b49ddd1a25f20d7a332e061a9f05b99d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "045318b84b0995512ce4f2a764f2b31c436e498bee841e85f19ec4250183ce93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "519f721015c95573eb0f8f75f140d213857aee76737683eaed1ae5edcd606c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8623d30017c4a826fd15c8d7d3662de343d99d51d8f7f095ece31269e9788c30"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6ab43e18da95a64270c5b045377e126810d140f784a9b2b5ed5bb29f909fd83"
    sha256 cellar: :any_skip_relocation, ventura:        "dc12fd5f5e60363d2d86ea52b53da6fc985f1a881d95bb96476c15f9e5e37542"
    sha256 cellar: :any_skip_relocation, monterey:       "20e540cfaf02ccfc3ebdb38a46e791c0ca5f35c60407c2c15e949e6e758e7b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90fbbafb47a51e36c18d2ad5f4bada5d0adc64db93618b023bc34b057180344"
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