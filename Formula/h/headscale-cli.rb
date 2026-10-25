class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://ghfast.top/https://github.com/juanfont/headscale/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "021bbd166a7b5fd2b6fdc28e4127dfa0cfd2a4090ac87a8ff6215b26dddba602"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b36ad5a46805ca5199e075ddbec15f5923b3fc3a2392f8989470494a99d839ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a974461ca4527ca9e7c3450ce617ab504fbf88100ab7619688b58fc6bedda4ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3a45663f18f37ba5575955914aa656ec1d561231eb3b099fae0aff2b28e304a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47cb39c51da444b5d06b54e3315c2688b5d4ae2c13dae433530678a651a48fa4"
    sha256 cellar: :any,                 x86_64_linux:      "68383136ec635744de707c0a1986be604ef886302bd3ee76925d6334e7d600ac"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"headscale"), "./cmd/headscale"

    generate_completions_from_executable(bin/"headscale", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      server_url: http://127.0.0.1:8080
      listen_addr: 127.0.0.1:8080
      grpc_listen_addr: 127.0.0.1:50443
      noise:
        private_key_path: #{testpath}/noise_private.key
      prefixes:
        v4: 100.64.0.0/10
      dns:
        magic_dns: true
        override_local_dns: true
        base_domain: example.com
        nameservers:
          global:
            - 1.1.1.1
            - 1.0.0.1
      database:
        type: sqlite
        sqlite:
          path: #{testpath}/db.sqlite
    YAML

    output = shell_output("#{bin}/headscale configtest --config #{testpath}/config.yaml 2>&1")
    assert_match "no private key file at path, creating...", output

    assert_path_exists testpath/"noise_private.key"
  end
end