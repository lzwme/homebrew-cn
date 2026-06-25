class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://ghfast.top/https://github.com/aliyun/aliyun-cli/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "3d80f041c75cdaed816ec6a45f980cecf0a240e0980d7f2a1621b953ec954bdb"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0e902c9d350d94f9e26bfce87dafd5bb13adc415438f2797a32bc4e1e6364b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e902c9d350d94f9e26bfce87dafd5bb13adc415438f2797a32bc4e1e6364b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e902c9d350d94f9e26bfce87dafd5bb13adc415438f2797a32bc4e1e6364b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c62c9c88537616c164b7993d1f19cf3d4d1e307463eb58f57d4a38ce64051299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2151ca00d13887d7b651a8e87831dcda2ca3e6baf31f435b25c2679ab6ce7b"
    sha256 cellar: :any,                 x86_64_linux:  "eab3783948c16289649cfa102cd200928be6165ee8e30045e268dcf08691d7e0"
  end

  depends_on "go" => :build

  resource "aliyun-openapi-meta" do
    url "https://ghfast.top/https://github.com/aliyun/aliyun-openapi-meta/archive/2563691c22229a0b493606e11166b95896707095.tar.gz"
    version "2563691c22229a0b493606e11166b95896707095"
    sha256 "7ba54333e467ddf5b25cc93ef883742b1817b44c48568bfee699450544537e31"

    livecheck do
      url "https://api.github.com/repos/aliyun/aliyun-cli/contents/aliyun-openapi-meta?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  def install
    (buildpath/"aliyun-openapi-meta").install resource("aliyun-openapi-meta")

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