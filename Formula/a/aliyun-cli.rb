class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.248",
      revision: "e391e238e978de446176330c59e37962f01496b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be3f11e0a8ba3140f27384aa0494341f03907d0604a838b69a81d626e88403f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be3f11e0a8ba3140f27384aa0494341f03907d0604a838b69a81d626e88403f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3be3f11e0a8ba3140f27384aa0494341f03907d0604a838b69a81d626e88403f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a211ff07b7b0e0bf42db0c495b28f2b50ad6550fad14263c7547ad89b085aadf"
    sha256 cellar: :any_skip_relocation, ventura:       "a211ff07b7b0e0bf42db0c495b28f2b50ad6550fad14263c7547ad89b085aadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8fd1d97d9d1a12a7856345bdd6b9ffb5cb0f09b493459222d2c859a63e40b8"
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