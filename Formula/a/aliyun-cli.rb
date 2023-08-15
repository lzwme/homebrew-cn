class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.171",
      revision: "7068f8e9ce6703e72597e3f1f4538ceff58440f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73050dfd68bdd0e8f2026010acadc931b3e90800ae67733a0ce8b7987af36715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f11beeb9023a4c350c360f436bc59438f986c6732d6d0e4da27ce1eadc95036b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d59fe374560c777570682fe78b28ff787b5c65d5807d2da1f23a0ab61d4ce784"
    sha256 cellar: :any_skip_relocation, ventura:        "1457b61815dcd9228ec1b8ec7649f600ebe4728d3697252a0f426a368a7cc663"
    sha256 cellar: :any_skip_relocation, monterey:       "5add98fbc5d0119a70bfba193da80dd339b5cd5391c3e3f596f2cb5a26270f83"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ff1a1e4773730b4051e99b7bc1315d7d5f8b7f75895885d88ec98947b46bb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7de94d7d4b897836ccf054c9785f9327e0cd52985453c4efff7bec6827f51cc0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end