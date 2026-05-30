class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.18",
      revision: "4887bcae4cfcd3f740dc9b4d9edc5aafd7e40d4b"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92a4996cc629feb1a1bf30207486334c4bb62de0d4ccf21d9a9132b7e38b3cd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a4996cc629feb1a1bf30207486334c4bb62de0d4ccf21d9a9132b7e38b3cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a4996cc629feb1a1bf30207486334c4bb62de0d4ccf21d9a9132b7e38b3cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "25f6f7952a4e28eef1eea884f38598c553caf18c6551c242d557fd9f35ab7fd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9d07d346fe5a8a79592ad5294e879aa604c7bcf8b24d3cab3c8a353c883970"
    sha256 cellar: :any,                 x86_64_linux:  "0c898a03f637f5690588a4339ffe53743fe2eed1976831fd11a54daf8c1c8f9a"
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