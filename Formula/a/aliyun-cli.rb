class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.188",
      revision: "851820daa847d60dddec27101619eca6bf4d366b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b30c6a41cd45fdd741b6a5d2d3e6ece951405abdbc665dbd292f8a551bdfa083"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9754d4b652054f41ba19766c4f26cb69ddf040c0a93b6eadbf1c340522b26b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548192691bf43a35d620253f00a0d94aad61e7383909c5b9f403835c34a23949"
    sha256 cellar: :any_skip_relocation, sonoma:         "30237c8889e5010e5e57704454498d55994e6bd2d7f3a2886c2c7a128a17da10"
    sha256 cellar: :any_skip_relocation, ventura:        "b130c5e2047caaa010039afc41bb08f8524f9fc6a4ceefb0e123fc301ddd9274"
    sha256 cellar: :any_skip_relocation, monterey:       "8328bbf81539d65d0e5c62cb579b1a1e7f17f30d75ef3dc610624efc42546cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9858045a0961103dbea643d6f6f7a60d6fb854229b2de0c962d695bedfe1957"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
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