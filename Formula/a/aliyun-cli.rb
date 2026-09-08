class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1593fc4ab238323724bc1a34d7e393f85dc7a7f2e0a900a6e5a48efe3b345179"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd6dea8d44d2a8f7b4fb7fd0f6f6e3bcedcf36718acc60b4da9afff1eb855358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b742d266b367898a89425cae20a1ddd8e2aaf39fda45421b97c6b3253fb69f"
    sha256 cellar: :any,                 x86_64_linux:  "2ef31bc97a96bca28a65454bdcc7dd67bec114f44f6c61861a78c31370b4e0b9"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://ghfast.top/https://github.com/aliyun/aliyun-openapi-meta/archive/00db11354cc523f310b1bd1bd73bdecc478e8ad2.tar.gz"
    version "00db11354cc523f310b1bd1bd73bdecc478e8ad2"
    sha256 "cbd5c1252b351130a1767e98dfb53ce40bd0cfa824301b256e220e5348ae20ea"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")
    system "go", "generate", "./bundledmeta"

    ldflags = "-X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "-tags", "aliyun_cli_packed_meta", "./main"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "Quick Start:", help_out
    assert_match "aliyun ecs DescribeRegions", help_out

    dry_run_out = shell_output("#{bin}/aliyun ecs DescribeRegions --cli-dry-run --region cn-hangzhou")
    assert_match "Endpoint: ecs-cn-hangzhou.aliyuncs.com", dry_run_out
    assert_match "Action:   DescribeRegions", dry_run_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end