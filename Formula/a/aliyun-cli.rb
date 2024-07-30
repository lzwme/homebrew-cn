class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.216",
      revision: "3b0f2b062b7fe66c052d727ed069808963468811"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86b28621335e83cc45d7b4456bc5e8b8e135aabdf8b702681b9481025f7ed8bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "271f4c60a924c687b8c248ef3f83afb10a12fd62efd522c577852f7cfec6e806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e417b19e718cec41712aaaa6194e203dbe915602acf143c6b497f5d1c87c5e4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "04aa8a5ad794cafc848b2e4e5240c0543ae8e8b92a28bad23234640c3631474d"
    sha256 cellar: :any_skip_relocation, ventura:        "b9acf035022f3a1e7e8a0a63c0315f8009274b0d73fdf4f90962561f86e50eb7"
    sha256 cellar: :any_skip_relocation, monterey:       "167c21c2a5a2f8a31bd9e863c3fb6eea905036ec658c0290f35cdf4db408e7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab4d149db5299d87c52afe9c16340efeba2385707aa01c72b8a5962d9d3ad11e"
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