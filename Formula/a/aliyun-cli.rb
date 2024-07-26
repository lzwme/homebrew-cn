class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.215",
      revision: "33e56124ec1599f169332994325bb86ef0d5fba0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9360bc23f4da2db425dc19536f875904a1ab802b4c62f70dbd9d362573f7b487"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2c2a33799450defe9af49c804d50dc30276ba42cf672552fb3443afca02cefd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f724c8a4eda61b0ffe8266eb1471a198e9014b2b688a18452504281e7b8bda5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "36b16b1b5f5edd0ef067065dc1eed02ad08d88ed4186feda7ea5894241f7fecc"
    sha256 cellar: :any_skip_relocation, ventura:        "a2ac4755335211eab071160bc56dcc77777500395568b2c52ed4f7deee492e2e"
    sha256 cellar: :any_skip_relocation, monterey:       "0b41ebe7a46fa7a40a81d7e368b254e6318990fb2e088afda8bb788959b93096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0c69050318c1fec9e97c5c16f0dd62c466558b4a49ba06b3328cbc80b8d78c"
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