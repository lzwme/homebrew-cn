class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.190",
      revision: "a505142bba2436ee4b78893040edacebe4654519"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "247025212b21d8af34242b437eaed7c6223cb923cebfa418a13affdf5b85ca9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d178aa3c7929486b2b3bf21baa59f4a0b84fc3319b72517aa546a812235a0623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b377ecf0cb24259734d6f539fd8d4cdb848b1eeae2dbf30032f3b6af1a4d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca088f1791cf1f962e144c2706b5fa96705119dd42f4923b0e13f0313c6cff70"
    sha256 cellar: :any_skip_relocation, ventura:        "c339e484907af162c6c52deadc3a0f5afee4f6bb0a3fbcd43887d913c0e9e2e1"
    sha256 cellar: :any_skip_relocation, monterey:       "424679a7ac34c623cfc75f317b563bdff766f60ee6fe7e88169361053b04bdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1d2aaf0b3f2863b44686eef3852f58e4633bb39eff3de469b3a60b202d1b6f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags: ldflags), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end