class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.297",
      revision: "9ce2fc58f6c6a1cbaae87177be7bda22986983bc"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1b3fd5f2dcb0e73ba31d972b8c0fe0601fd1a7c34ee4eb1a919fdc4fde4403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1b3fd5f2dcb0e73ba31d972b8c0fe0601fd1a7c34ee4eb1a919fdc4fde4403"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a1b3fd5f2dcb0e73ba31d972b8c0fe0601fd1a7c34ee4eb1a919fdc4fde4403"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff71d0b5c104dab4b75bdd06261a4c5c87c61d59b2622e180d7e6a93a06c5eb"
    sha256 cellar: :any_skip_relocation, ventura:       "7ff71d0b5c104dab4b75bdd06261a4c5c87c61d59b2622e180d7e6a93a06c5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa7617b86e18209a8cb7c46e5b8c9cdb577fb6853ed31e2ea1949c2b2d360f2"
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