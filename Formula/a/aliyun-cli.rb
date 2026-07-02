class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "64b39f1962529ac5d8ffc7a29d716492c58a3f228422e3b9c6dde38bcaa7a2b3"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d222562bad5b86618e2618b92651901c9f78d020804d6e5d88ca4a6a7cb28ada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d222562bad5b86618e2618b92651901c9f78d020804d6e5d88ca4a6a7cb28ada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d222562bad5b86618e2618b92651901c9f78d020804d6e5d88ca4a6a7cb28ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1310e902afe270e92b5d8977b1dafe8efd591d67ce3d9a343eb9e3141aae2eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660454c33e68189759352d2eed04a84b7514544dbbf1fdbc32cd6aa928684554"
    sha256 cellar: :any,                 x86_64_linux:  "f05a1da9ed40d081ab73e1a1aa57d82e364e0bd038da2750c9f5a81c9dfb5124"
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