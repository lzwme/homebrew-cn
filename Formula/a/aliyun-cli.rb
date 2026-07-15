class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.7.tar.gz"
  sha256 "12123fc7c860bec3c582bc9350237943a778d341a6f15b39652ae43add018898"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f505f4f1aad7d9423e717e1b9549c6fc02ce9c73c505306eeb9fac394a018c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f505f4f1aad7d9423e717e1b9549c6fc02ce9c73c505306eeb9fac394a018c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f505f4f1aad7d9423e717e1b9549c6fc02ce9c73c505306eeb9fac394a018c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7481171d69791f356a354440d42cb8c8006c3c53742be5562d9a2d3078c0b7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d68c75be3d6d240d98b5898b396ad890b2aa5814ccce84a51a866321859044b"
    sha256 cellar: :any,                 x86_64_linux:  "88b2d3b38d8b358a3e1380cbc52b576f20e5d364a38a40e5c1ffc05661909806"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://ghfast.top/https://github.com/aliyun/aliyun-openapi-meta/archive/2563691c22229a0b493606e11166b95896707095.tar.gz"
    version "2563691c22229a0b493606e11166b95896707095"
    sha256 "7ba54333e467ddf5b25cc93ef883742b1817b44c48568bfee699450544537e31"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")

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