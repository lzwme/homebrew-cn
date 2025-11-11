class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.3",
      revision: "6287819958e9aaaa1aeed89d4e764af1a90845a3"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ac2151b03ce6a99f86da9cdfc3fbc8d5dc726e709d25f527f1ac7ae6b26eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ac2151b03ce6a99f86da9cdfc3fbc8d5dc726e709d25f527f1ac7ae6b26eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ac2151b03ce6a99f86da9cdfc3fbc8d5dc726e709d25f527f1ac7ae6b26eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "98847875d2b8a95ee6fd2294b70e04754d662216000cb882b30453c1031b9851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb13f489334203722d64d0e9565cd40795e9c9444f3a36465aba0d7c0eea3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098da9b8278ea91a3294f2c46c88a8ec61105ef6c6cc8a2c1edf908a8745e9d7"
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