class HeadscaleCli < Formula
  desc "CLI for headscale, an open-source implementation of the Tailscale control server"
  homepage "https://github.com/juanfont/headscale"
  url "https://ghfast.top/https://github.com/juanfont/headscale/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "dae8ad94078c1447f566f1f0843afae48cd11e78d7b0af400d01cb53112dcc3c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f606d2a20c953551e3dacf61ab4acc1c0e947956a47b5372df29ad55bab932cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7520ef980a345dd08830bdb9bdaeb01477b65f83065e0b527ec8489d7f252de9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "431f3183c2f83e513cc0d558e0b5c81026d3ffea4608e625361077ddc8392149"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4c01e0b08eab87608a3e30a296ce6d7c7d08a86dce2bdf5db516511b1555697"
    sha256 cellar: :any,                 x86_64_linux:      "afde48459ea0913b575b25e12cfc90d9d2c0f739ca7b04b230ba8d7c3bd95a92"
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