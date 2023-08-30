class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.178",
      revision: "ee857b5d5843182308716f29b4b2371cb62ca7eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2749bb12c3a0b598acb3abdfbd04ce8af4881b922c494a8bb75b3ab9cabc6600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb5d288f7373cb9718dbb472e4ba9c0b3e431e5519f4db18565398c54c8b626"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "128d2398be153ec9d7f1ff3464bcfdf7634e8e00db73506518777f4e34361938"
    sha256 cellar: :any_skip_relocation, ventura:        "28bbbc5b524907f63d627efd9bd5cdeb10d091f82a98308439819d7a07ef1fea"
    sha256 cellar: :any_skip_relocation, monterey:       "0703a3469f2cd91218f56214c641ac78b113629cacdc2f141b9a45c8fdb46455"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2029ee3c79dbe19cad9b40d886dcc097770d6651d99cc7470edc5e7e001a5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579d26692f2464e747f774b08b8c28914bf6f1f92cbc30e76e24f3fc11fe772b"
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