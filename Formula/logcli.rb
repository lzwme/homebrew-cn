class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.7.5.tar.gz"
  sha256 "8bfc01da348e875ff7a999af3842a14e2c698e06facdf486754127991d6b8f19"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ec1cba26d3a045a646e2e153c1f755447511fa4c8c4e9d32a7c121b185b241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad77ba650cf40dd367186b996a450ee6248a787d2d59900bc1da2a27c78cb81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b6dcc48e46bc21741aabba1806a165fc97faf6b2dec06bbc030b77c654e2fc"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f5f458251bd9362f73dbf8c7c584dbadf2c3ea212afe5c9cb6bc3c7bb7bd04"
    sha256 cellar: :any_skip_relocation, monterey:       "ddae74e77e8bc208a2194be51cef99745d7951934224f37086f15909d3b3d193"
    sha256 cellar: :any_skip_relocation, big_sur:        "34542f8b0426df19d7f0b3960f399464f90c2f326f044119f1ed08532ce8771f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29ef8086b5341fba066ca4c53774922b3db310fb3e51ed6ef324a7e6fc9fdda"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end