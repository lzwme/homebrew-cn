class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.15",
      revision: "39c8ddbaf09fd7563325e52d4e406d7ada9235f3"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74c91d4e3dae2f8b6d699b6f3fa5185541854ca1316c9014221a36b0fe8fc424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c91d4e3dae2f8b6d699b6f3fa5185541854ca1316c9014221a36b0fe8fc424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74c91d4e3dae2f8b6d699b6f3fa5185541854ca1316c9014221a36b0fe8fc424"
    sha256 cellar: :any_skip_relocation, sonoma:        "e387ce667d6b80fed8012660e913f5279ca81f760dfe9f713cd3d287cc4677ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a844c285e231501acb467c3ab6fc141582b0c5b5494927a0ea843dcc5216c299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81639ea08706aae0d23cac4892714a44413aa876dd7781c4a8f83403b1252869"
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