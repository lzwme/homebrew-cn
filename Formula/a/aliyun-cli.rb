class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.218",
      revision: "1c13a699b7099510bf8e476adda16e45ff5ce31c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7f02de748c5acbed9b561067b356147e37c995ca34e875a314e39b250196e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e25a46acd7b4530b6e08571af5c9b5cd9635a22a3bc28afd5623a8baa0b47d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900d4224627cc2cc732934efc26162066fcfd8f5479217d26825d2720626237f"
    sha256 cellar: :any_skip_relocation, sonoma:         "32164c5ac27f007aa3f2acf046cf3fffa9dbd597111344744f108f41406ee964"
    sha256 cellar: :any_skip_relocation, ventura:        "2225849e8f274bd6cc67a6b76d9b83d6df4801f0ead1c018db9f3c1e49939b51"
    sha256 cellar: :any_skip_relocation, monterey:       "c91f4e0946f282962043b112a1e6427bda0ecad566159d5f72efc8f46962ab41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1efa6ed832c1ac329957557f22f68a868a7d280824f66d2d1c63259b3fe517c0"
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