class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.184",
      revision: "75e2b8a51cecb0d59072390f8a134137d898ac91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3bbd341a7e73b752323c8dc7643539a4c69a22a2c52e5e36969af23dd596f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61c4e300211e61a5e36612121877aab7ecc4a735800a9b0418cbf8fef3b0527c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fc5006dd97d55922b96fc2835ee2199301b30ec9efbe4906d5f64ac7118de2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "465b2ad9af2234b6a24ff9fa40da82a39c1fbf1a4c457b70e00e7026e7f56197"
    sha256 cellar: :any_skip_relocation, ventura:        "43a17afd572e3f539a27e7ad543b4500c01c16066009a64dc375050f0587182b"
    sha256 cellar: :any_skip_relocation, monterey:       "683218d99e660fd2adadca311e2825cc1daafc429f25c1e7f038724ca01d40eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1b26310a95b0a2b9b3937fd47424d5839c32d9674e688d5de7f3d89fa6a574"
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