class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.203",
      revision: "0e6f9b50a2e15884a443a0b4618622d1d180c594"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46590cc8c0f6a1209aac43424bc5a892cc6ae54b30073a37cb15d29b06f8ede4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7808032c86d120fb5d3919ad5a48817f4dc1e7a1c033fbd9210e9db8d2defcf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75203d7b80fb7b8ee9c26dceadc5d4251fce97e53c918d0b29ef8d270e44fe49"
    sha256 cellar: :any_skip_relocation, sonoma:         "097037ce93828afcb115077833145706004d8565cf3eb0804870999f9f24f3d9"
    sha256 cellar: :any_skip_relocation, ventura:        "a337bd3f138bd8e798c17eb99de6ad71d082f2a7926564f0f35e10ab8bd75d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "ee0194e734803dbf2417ce177056be1fe9d3c1c1d92f5d9302b1211bdaccf5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1de208d5a59362f39500a099d701b384e2dcb2551dce35ebff188c14c32f0e9c"
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