class Erpc < Formula
  desc "Fault-tolerant RPC proxy with re-org-aware permanent caching"
  homepage "https://docs.erpc.cloud/"
  url "https://ghfast.top/https://github.com/erpc/erpc/archive/refs/tags/0.4.0.tar.gz"
  sha256 "72084f5e865807e15346f9670645b46fb705803f297c7a59b603fe4413f19159"
  license "Apache-2.0"
  head "https://github.com/erpc/erpc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e823f5deb6dc96f271eaf19c4ebbb977b43a074119afd56cbd6800f324cf8a6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "523bbe064a2b7ad81c4484d0ad10bb63e304bf345e95472fe6546cf53f9b1f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "833aa8d565a4fadcb72919bea9344ae727f11aad3eee67e0ae86f37253825e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ec68b82903aff2095b2808db0a2d60b733f152ae9f7616eb568fad6e3eb2d53"
    sha256 cellar: :any,                 x86_64_linux:      "9e643775c56a1d0964e653760134d8e8a163e7bad2be3fc326d8611e33ac44c5"
  end

  depends_on "go" => :build

  # `test do` block starts a local RPC proxy
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/erpc/erpc/common.ErpcVersion=#{version}
      -X github.com/erpc/erpc/common.ErpcCommitSha=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/erpc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/erpc --version")

    port = free_port
    metrics_port = free_port
    (testpath/"erpc.yaml").write <<~YAML
      logLevel: info
      server:
        httpHostV4: 127.0.0.1
        httpPortV4: #{port}
        listenV6: false
      metrics:
        enabled: true
        hostV4: 127.0.0.1
        port: #{metrics_port}
        listenV6: false
      projects:
        - id: main
          upstreams:
            - endpoint: http://127.0.0.1:#{free_port}
              evm:
                chainId: 1
    YAML

    output = shell_output("#{bin}/erpc validate --config #{testpath}/erpc.yaml")
    assert_empty JSON.parse(output)["errors"]

    pid = spawn bin/"erpc", testpath/"erpc.yaml", [:out, :err] => (testpath/"erpc.log").to_s
    begin
      sleep 5
      assert_match "starting IPv4 HTTP server on 127.0.0.1:#{port}", (testpath/"erpc.log").read
      # The only upstream is a closed local port, so the project has no healthy upstream yet.
      assert_equal({ "main" => [] }, JSON.parse(shell_output("curl -s http://127.0.0.1:#{port}/healthcheck")))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end