class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.1.6",
      revision: "f0ac53f13d409bfd39c2462192db56618b03ee16"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1ed0f18bfe4bdb7e68d581669dd89c136cc112ffe6f4226ed39023eb4e472d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ed0f18bfe4bdb7e68d581669dd89c136cc112ffe6f4226ed39023eb4e472d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ed0f18bfe4bdb7e68d581669dd89c136cc112ffe6f4226ed39023eb4e472d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9faf82de38e5a6e6bc1dd94b79077e36d3ff74f4c6888c194b7a22f3c452db4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2aeba8085d6c4559beba50cbf17f8c72edb39ed4d2d8135a4c13a6e23d8762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6404ee5953c340a3f09dfc8dc7ddf626b957ce9c8708d43b6028330331bff3f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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