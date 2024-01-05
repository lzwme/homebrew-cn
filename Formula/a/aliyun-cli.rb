class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.196",
      revision: "6b5e9764c410ff0e4949b961346a0ee62780b3e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb4f596cc03482f7f05421a7f957866edd8bac9c1e02bf24333a93d4e7d4d848"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9481054bbf8f82cb928135a2818cba4347d70d8e586643c9911cbd5b404056ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c9b906a0b7feb75d0dc9719045d389675569e09284500d7c54104629d833f80"
    sha256 cellar: :any_skip_relocation, sonoma:         "367ed4a644be2b38f02c9d672ed3e25852fc288b8720ec54281341e09187cc29"
    sha256 cellar: :any_skip_relocation, ventura:        "f21f815a6479c7a7f9d22eae6a227a20a01ecf82b9afdf1c00d8b1edddf72cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "76d773bd1ec1662bad2b6bb98446fe1141629e97c6776f36b70fb14aff93a241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acda7c08344e0d11a8e77fab7fb4bd2fe0f44d4ccab4c0dc7ab3e808f1f9928"
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