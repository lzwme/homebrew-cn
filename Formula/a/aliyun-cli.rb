class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "d03eeaedafbdfff43c592c4ee136e51bd177df3bc041b3eefeecc834f4e6481a"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d636688b4638a057e6e868a47729027db5d5c2a83966951e3d2d734d7fddbd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d636688b4638a057e6e868a47729027db5d5c2a83966951e3d2d734d7fddbd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d636688b4638a057e6e868a47729027db5d5c2a83966951e3d2d734d7fddbd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b678a665715e4455ae57f758e630424ae26efbb589506871db579e215abc1255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44096b49d32d668c4bb5aa6941d85733788d043e55cb94856ab9501d4c5e4bd0"
    sha256 cellar: :any,                 x86_64_linux:  "7b83e8a02c5630bf386322838f1ab0374cbddd254ff5e0e44ca1e9dd4c7ed8b5"
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