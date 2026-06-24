class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "308550dc232bcbb79df92e3fec0dd3cda47ceb5ab9e11cfb4286d5761bef2d84"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b9852eb6a218a0b3201829132109cf112ba035994f01cbc437dbe697031969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b9852eb6a218a0b3201829132109cf112ba035994f01cbc437dbe697031969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b9852eb6a218a0b3201829132109cf112ba035994f01cbc437dbe697031969"
    sha256 cellar: :any_skip_relocation, sonoma:        "b63184b7ca6818e9fafec3334dd5921c2d06b9fab3d7708e14a39f39ce06f4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe7aa5fcd9f01641be6fa60b3d9a677879574ac8f88de8823e18825a249ea89"
    sha256 cellar: :any,                 x86_64_linux:  "d83be5703e23a61940016d0fbebaf9af966f217ea744e85363eb9cdb267fb5e5"
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