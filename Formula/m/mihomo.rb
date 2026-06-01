class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://ghfast.top/https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.26.tar.gz"
  sha256 "c8e4a970bdf76aad9987ae42650c47c4ca1670413f557609b43ae8fc47759480"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f81ea3db7f07428440739c1cd28906572d5ebe8726e21f37180012d49ac00aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87eb7b1735ba0c86e0ad4c4480beac74b574a18eb089eb947936158e5bfe4f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09e622744cd81b76e3c446a39728784bc7ca5477f9fb9d2a2575eced06c9e16d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda0a2cfc117bb67cc61e302bd5ec8b7ba3e88e42b2e7ca73cb0ba7967d09650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8027246c0c1e90e423062f80a9ddb56ab1c60d9a188607109f1b1dc3ee756b37"
    sha256 cellar: :any,                 x86_64_linux:  "cb8e0e6bf5a49f5e4e7ca94d204e4dc1639342312f9cbc60d5ec2171a2f0bcc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

    (buildpath/"config.yaml").write <<~YAML
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}/mihomo/config.yaml.
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    working_dir etc/"mihomo"
    log_path var/"log/mihomo.log"
    error_log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    (testpath/"mihomo/config.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end