class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.197",
      revision: "e6f2cea495dc81ac11c29a874f3055f8945b8c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ea95fb826edccbf7a48defd5bc58e972cb10762ccecf94cde36a334537d8626"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f233322d04c17c9d56e078b0cfc7d18735be8a40c3f612566d7a862ec397ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d51a5f20ca53c45ac3e6db6f62e12f6dcaec7497e8107851340c4c82291f998"
    sha256 cellar: :any_skip_relocation, sonoma:         "27e62056efd02502c8fd9e86604205d04a7745d6863b95e84c594e7d3854d1c5"
    sha256 cellar: :any_skip_relocation, ventura:        "2d137a5b619c1815573a9320d3816b3843a30b30ef97246f9b8b1626c11f685c"
    sha256 cellar: :any_skip_relocation, monterey:       "72d17821c5d4d6934115cadf347523a9ca379c4be7c22f06e7f2f1117d4d673a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08195931e42327a5e33f51be2f6fa1464abb5dfa4f7ad7020edb870a17c54729"
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