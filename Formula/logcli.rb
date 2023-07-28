class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghproxy.com/https://github.com/grafana/loki/archive/v2.8.3.tar.gz"
  sha256 "d699b24e1b5f823603502359045a39d0cff3bfec69bc5a6836a16a42bc10b53a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b0562e018029a7a585a224a14bfa50c1b52d871ddff163f80e7f60f0141e9be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0562e018029a7a585a224a14bfa50c1b52d871ddff163f80e7f60f0141e9be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b0562e018029a7a585a224a14bfa50c1b52d871ddff163f80e7f60f0141e9be"
    sha256 cellar: :any_skip_relocation, ventura:        "5216f37d616be5604c4c4ee54838e2c0dec5a2bd4420a2a525645de4818f7680"
    sha256 cellar: :any_skip_relocation, monterey:       "5216f37d616be5604c4c4ee54838e2c0dec5a2bd4420a2a525645de4818f7680"
    sha256 cellar: :any_skip_relocation, big_sur:        "5216f37d616be5604c4c4ee54838e2c0dec5a2bd4420a2a525645de4818f7680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "582877afd41bc0c00514e7e15fa645a00e34f528d40324d405a0d87e42cc84b3"
  end

  depends_on "go" => :build
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