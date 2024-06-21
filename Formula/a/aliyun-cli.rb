class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.208",
      revision: "c3de4e38a8236df009087ae3a30702a116e1b960"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec9f53983a7b61f6a0373e1f3fa9d3c255646f2b3dac2a92381787e210ec86fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98e222d421184024fdc5b80239e0aa4188f0e4fe3658fce39b3254cfde5604e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d57948518d847fb1a089b692a0d4ed0f4a6265aeba6192b972ae0c5b99abcec"
    sha256 cellar: :any_skip_relocation, sonoma:         "968b1c602d9b37024cb476dd1985ac41cab795923417c21c8fcaa4b15403adb3"
    sha256 cellar: :any_skip_relocation, ventura:        "2ca614a32cd280eaaacd3896819551cd4ceeaece64b8d259f4a915bc2343dc6f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae712558040ce7a2b4c3ea41bfb52e5ec976555e136e682431c50c12de01c813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7827ea68dfe1eaee737cb24b1f168cb8f97d0829caa08eae0d6c0ee5f00d35ed"
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