class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.194",
      revision: "58f445a5271db3d5f806041ac480bf45cce2d47b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21aaedd521ff359a1e88fc6a654f35a91af2e03f9b0cc4f2f5b3562bcc5baaf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ab4593e8052451034b6454dc735071bfca2694c59a98e7a459d2aff789f519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36f760f7579c89db4790c1878b394b5767a8ade0f8c2763c23d586c32f0cb08"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bbe3ee7e7b2cd2bcead94c96b1699235d236343e777c91941b2c8f4fa3df14a"
    sha256 cellar: :any_skip_relocation, ventura:        "2d07712b0521166fa4d5b2b8e5a9a6ef96f7e28947051996d3a1cbf8c33e07e0"
    sha256 cellar: :any_skip_relocation, monterey:       "db5d47277070d4fc55ecea797ca55673963f6b8fa7029b64166587bc91b764dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb25ae0634d1260b0234310bfa57a617bd2663680ecdfad37cedbcaecacf93c"
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