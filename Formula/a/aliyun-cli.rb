class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.186",
      revision: "370881246e0bff80f5961cc462c92d8cd8d00379"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e98c1d1f3cfcda16e76ecd97fd27122902f7bf0896bd5ae150b15ae3679121ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c910d0d0c025361040c9197c38dcd77aee7450670a9a9cf923c11aa882676663"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c23f7357097433c267f51f3ee09d969f2a6346f6b876a0300695e61c1a282c4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b2ce6339c06983e70767e298b0ebb07a34ab81fddf699788d1a5c13d8d022bc"
    sha256 cellar: :any_skip_relocation, ventura:        "a4ad12f09b90789356b08d0dcd60a68bfec18df401ebd0cf322fc6cf4bd9d00e"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5c7d6943450d6ed1b94c7a3c8367aadad8d0ae87eae830fe00932e7fad8d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4998ebfc25bd80b837f4ccd255fb4c0527750f3e2cc4bbaccc96e59915e34e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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