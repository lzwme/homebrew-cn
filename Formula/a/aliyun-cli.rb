class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.187",
      revision: "412882ce4f2a882d03a17a4ace458d8a7d290032"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73589795b843593d2bc65a9e423cac5d0a777dc53e377a7a32b7c8a73c7a603d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6945310a0f3d66fc166179e9081b3e805c71eb6ce20a2ee8bfb5db9c5ac5f5f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1f153fcba1a169f6d7079594fc62fbe84dc0e71bca661138762de38b8f47546"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b7f156d473b3fa5c439bd30989fb4999cfafccabd80159e9ac10f3f149aac60"
    sha256 cellar: :any_skip_relocation, ventura:        "3fb151a99cb0ae48708194485eff8380d60a118af2c658e164b633beb4d01409"
    sha256 cellar: :any_skip_relocation, monterey:       "bddcc488b2d356c9e4d22cd28962c0f043efd4493a4991cc50acfa43ba2d7045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9b5b0d2e97a1091acaed665d4818b74f19d312a1cb3edcf8f9c673405010ea"
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