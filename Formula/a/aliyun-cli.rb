class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.270",
      revision: "0a6172873be8899fc50c2911ad4049388ad6498a"
  license "Apache-2.0"
  head "https:github.comaliyunaliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dc7ce8b9a3dc28390dc60811cd69af090357ac04d5f168457262fe164e3eb58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dc7ce8b9a3dc28390dc60811cd69af090357ac04d5f168457262fe164e3eb58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dc7ce8b9a3dc28390dc60811cd69af090357ac04d5f168457262fe164e3eb58"
    sha256 cellar: :any_skip_relocation, sonoma:        "49061c439a94806475556b94abac553c1ae3f77e05d10bf88c48268274076bdf"
    sha256 cellar: :any_skip_relocation, ventura:       "49061c439a94806475556b94abac553c1ae3f77e05d10bf88c48268274076bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d84fca0305e598d9f9654324f95b0208be1f3b66841ba45c7fd26cd248e96cc"
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