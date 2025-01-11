class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.247",
      revision: "56f55b923017cebfc3c8e92e8bdc42c97db9f78d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258d44f52a278ded411d22e40de94f22b2e7f46b7f49f608040a140752d41244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258d44f52a278ded411d22e40de94f22b2e7f46b7f49f608040a140752d41244"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "258d44f52a278ded411d22e40de94f22b2e7f46b7f49f608040a140752d41244"
    sha256 cellar: :any_skip_relocation, sonoma:        "a83170892a32d83e8d1968b073a740be2989f8debacfedffb713196aa302e4b4"
    sha256 cellar: :any_skip_relocation, ventura:       "a83170892a32d83e8d1968b073a740be2989f8debacfedffb713196aa302e4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd301ebfed112b209fef99c5beb93b4e96f7478bea3cdb9e835f2c5ab19e29a"
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