class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://ghfast.top/https://github.com/pomerium/pomerium/archive/refs/tags/v0.32.6.tar.gz"
  sha256 "05378c287452bc9c5cfa336aea64fbbbc8d1906a8a5cc70ce2668c18db7e40a8"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bdce1619d9bc9c8b8e4175a20f84e598dc0991230947f5d3a155d1a8eaed982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7bc1c0f162f322594698e249442c240c3d26417b2fa79ef1287d570c29b27d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da2b697f44af2a05c4c61fc4896a639d7483ec48b30128ea7806bf86d75fb7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4517ea23788d831c00348626d071ce821ec6d1197d9e9355159d534f506bfb6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21563007063b3b1d99fcbc78d00ae94b46a0fa8b5ed287f03b13afb9de70ad99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c116908ef1994544e0b254e04a934c02e0fafa9df239a040dbcdadef63dd22"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "make", "get-envoy"
    system "make", "build-ui"

    ldflags = %W[
      -s -w
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