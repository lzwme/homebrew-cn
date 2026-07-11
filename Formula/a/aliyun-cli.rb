class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "fc853e3a19a03de3bc7c6a598affd6b72d932948f15434ddd17ecdfe6b5aac8b"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e97e7cec8895d212396e391c02f85d88123af46748d292da3391ebdc921e5943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e97e7cec8895d212396e391c02f85d88123af46748d292da3391ebdc921e5943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97e7cec8895d212396e391c02f85d88123af46748d292da3391ebdc921e5943"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c6672e866483ef5c667fe8f12b44f138475f3a4ed986894dbc19ae65fa79aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7eb4273db62637547f286780d5a1d6f0707ef881e060cb509e05624a5c7aed6"
    sha256 cellar: :any,                 x86_64_linux:  "90ba4293b1d5507b78ebc0e6568a54c2c4c347d6a6f96169313a2230ec3e8c04"
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