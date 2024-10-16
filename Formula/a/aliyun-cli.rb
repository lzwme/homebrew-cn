class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.226",
      revision: "b2598121388f354cedfd7eb8870cecb9d53ae38e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae6a7d859e83e09c8838a47541dec4196fc6ed27263bb30596531047c162e40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae6a7d859e83e09c8838a47541dec4196fc6ed27263bb30596531047c162e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ae6a7d859e83e09c8838a47541dec4196fc6ed27263bb30596531047c162e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a704d0d392acfda1ae44afaa326464cc983dbc48307f9c65996e77949132cb"
    sha256 cellar: :any_skip_relocation, ventura:       "42a704d0d392acfda1ae44afaa326464cc983dbc48307f9c65996e77949132cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3157c5d44ab0a58a19d547672bdf1e3fa95de7889c250680192d3319b527c935"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
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