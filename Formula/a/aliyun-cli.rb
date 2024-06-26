class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.209",
      revision: "9c1eb2b4400d6181c0c706ab6334bb207e90807f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5990b7dea5ccf6583cdf69f0373ed7f80869f46d21138c5a54bf69704764bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4702b52317228a9201678418fa1d5961afda4c77dad3210272ff8479c6f05ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b43405966d323fb5b7d9793a50ac5da32effaf43956946cd43f268b52d8f6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1775094b2d90afa00250e9624320a598672b9fc4f88abdd54e22ee8f06473ab"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a1cf5fcdbe6d8623fe84c72e15ed70fab319da27889b22202324023107cb0f"
    sha256 cellar: :any_skip_relocation, monterey:       "80b5b2591c516710dab9b1bbc0099b8e993be21065c9f9d6191b065b6cc200a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b54a6b45a1011aa38cee726f1bac019b2e5276d0a6c235cba784577494a705"
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