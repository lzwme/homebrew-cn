class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.3.23.tar.gz"
  sha256 "99050ed6f84c4a240b4f1170f0a65961e23fde90aa67ad473eb523384ee4e58a"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31ef3a91608627825464ee7cff1a82a92b1d27d8f5411e02ca6999ad8c44b835"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e21b84e2c54e74a5fe9798fc4edd40e7c465d25798be3d93d3ba8dc4cfad4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72498868287db7473ce0065346d5e344c689fc36cdbc31a2a72c2eb9d73056c5"
    sha256 cellar: :any,                 x86_64_linux:  "48f20c3f9ca136335038979e3225f308995edc91ec301d31b5bf0254193168b4"
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