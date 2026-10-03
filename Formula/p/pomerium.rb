class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://ghfast.top/https://github.com/pomerium/pomerium/archive/refs/tags/v0.33.4.tar.gz"
  sha256 "477bb4909f44b32c73d30655ef21478bd5b403922cf2bbc1549c97286ff2658f"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbf773fb119f7298b47b97ec262bf89bf0203151ff479e9be3e11528f28052cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbc284f0f9757bdaa0f9d029b3db5e6f56cd9028fcd96bbf8009916f7888f2ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b9fb7c240ac2fc7e90801917f0199f79c219e2872ee3704db49f80bb0ce9cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "966d851cd86bf5316c79bf68f9133b15a9c8512109887ba1db34b0a2fa7a82b7"
    sha256 cellar: :any,                 x86_64_linux:      "d66c849d2729e65199c05243e0732e8d8783a84ffb296c28b66949f586524389"
  end

  # TODO: unpin go@1.26 when pomerium supports go 1.27
  depends_on "go@1.26" => :build
  depends_on "node" => :build

  # Upstream dropped darwin x86_64 support in 0.33.0
  # https://github.com/pomerium/pomerium/pull/6141
  on_macos do
    depends_on arch: :arm64
  end

  def install
    system "make", "get-envoy"
    system "make", "build-ui"

    ldflags = %W[
      -X github.com/pomerium/pomerium/internal/version.Version=#{version}
      -X github.com/pomerium/pomerium/internal/version.GitCommit=v#{version}
      -X github.com/pomerium/pomerium/internal/version.ProjectName=pomerium
      -X github.com/pomerium/pomerium/internal/version.ProjectURL=github.com/pomerium/pomerium
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/pomerium"
  end

  service do
    run [opt_bin/"pomerium", "--config", etc/"pomerium.yaml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/pomerium.log"
    error_log_path var/"log/pomerium.log"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      insecure_server: true
      address: "127.0.0.1:#{port}"
      routes:
        - from: http://127.0.0.1:#{port}
          allow_public_unauthenticated_access: true
          response:
            status: 200
            body: "plain text"
    YAML

    pid = spawn bin/"pomerium", "--config", testpath/"config.yaml"
    sleep 10
    assert_match "OK", shell_output("curl -s http://127.0.0.1:#{port}/healthz")
    assert_match "plain text", shell_output("curl -s http://127.0.0.1:#{port}")
    assert_match version.to_s, shell_output("#{bin}/pomerium --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end