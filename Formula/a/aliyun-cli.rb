class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.179",
      revision: "e15f651c13bf8fe7dd1f80018d077b1a09433362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb8e965c4c0f83745e2903ae180f469e4974bf2a484f3ea4f32b98027bce06af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71b41cb6f8ab3916608f382489192fe0dfd2e8fd6a2e1bdc51617623bb6f23a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeed52b7704f2284beefbff8dba42d86724d2bbaa0a63338fd4540f0d7a43fa0"
    sha256 cellar: :any_skip_relocation, ventura:        "e718f62d8056caf28e5ba2840677d197820986bdb22a35f8b32b647a08ab16bc"
    sha256 cellar: :any_skip_relocation, monterey:       "30bea8ccb5dd4c61fa794863053220f9d471b5e036e7374b194c92945ffa68bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b919dd0d4909477063913ffdbc7679c237f38f78858771e2cad1b3dd0d59c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e95faf4d233c9abc1c64a3404f057414a987037bff190664cec7f17a03e835"
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