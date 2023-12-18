class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.189",
      revision: "2c69e339a535773b22aca19b67aac0e4ddbe732e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1453dea416e9e031aa50d94cb9e67f35a6033c4451a2c964391783a32cc785e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db1624c726a16f0ac53eb856ce637ac8bd6d1b06eae40a7b3577272e007319c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567d86115b72cfb384367e1e2ecbafcdc52fdbdf9d3587f596f47212ee363163"
    sha256 cellar: :any_skip_relocation, sonoma:         "2381f8148f0e5d464abb98dd9f3dcd5fd2f901dcf54734ceda46424a95062862"
    sha256 cellar: :any_skip_relocation, ventura:        "bc01d5fea73e31cef55054fad2779ef3d259d904cd628bcc4106bfa608a7ce60"
    sha256 cellar: :any_skip_relocation, monterey:       "fed5f321faea177bfacedbbc6284c9fb2c56f57f31cbf2a3b1529ac636f87457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9511e067a0ad3868b59b2cac54938ac7e16049dcf6c25ba5a8c94eb8f32b670"
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