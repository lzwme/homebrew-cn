class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.273",
      revision: "85bad7f187c25b022389df407f09bcc1ad043368"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d295a261b628d3f38a3d340fc45816b6515b9486f1be300e852a98beaa4094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d295a261b628d3f38a3d340fc45816b6515b9486f1be300e852a98beaa4094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44d295a261b628d3f38a3d340fc45816b6515b9486f1be300e852a98beaa4094"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ee79fe821b95c1f370067dd744d2e1e68f029f560873606447bc037999217c"
    sha256 cellar: :any_skip_relocation, ventura:       "93ee79fe821b95c1f370067dd744d2e1e68f029f560873606447bc037999217c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc239941857162ea6637364e3ade096376c1cb5911eb597330d7f38bcfa8fdb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-cliv#{version.major}cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
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