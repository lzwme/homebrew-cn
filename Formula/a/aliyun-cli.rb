class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.211",
      revision: "cfa2734ec172ae2fccfb71ea8797fda9092b2a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d707d24470075073ff97859ca9c00f359a2aa3d3d44f845164c6dd7907b29d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31a66e64325292d942ad6082ea00b496d130ebe00aa938f0d0adc440b4debe15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e21bf07e5ac96afc585bb4d74e1d8a1a7fc2090ec41a0031fcae6c0f0b86735"
    sha256 cellar: :any_skip_relocation, sonoma:         "867f75a15430195589e141a7701fc203e2a8b3d400ea4b15111c8847a74313f5"
    sha256 cellar: :any_skip_relocation, ventura:        "2259b31df5845204e20f7e8a70d2ad89a17b86e7f44fa660d44580ae94cbd56f"
    sha256 cellar: :any_skip_relocation, monterey:       "3581401c26b716ed1c1b1db3a5801544b72641e3980669b210640541f4c467c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b5ef6d7bd5b57b2286af4e6c1bf31353cf1b9ea68bd89838c33d2628dce3a4"
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