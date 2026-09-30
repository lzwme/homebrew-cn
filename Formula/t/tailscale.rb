class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.102.5",
      revision: "5fb2a81b065b0a0bbbfc67ab20a0d9c6a1108115"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2af361b33c615db1f84cd92666a76caf887b7cdc5499f8ae1b81e1ed26708ea3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9727cde94aeac170b4477e11e0b6091109c0208e4b59be7b39747e228f993380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfb46f8ae922d0e3fbad74bd161539d16e07db07e53b2d611ea75a192f928871"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37d17bab2551d096f1422fd6c107a8c88457ea36efa686abc1c03ca3aadfdea0"
    sha256 cellar: :any,                 x86_64_linux:      "f108245a62241bca02c786dba12eb9addc38adf2b11e99e0e1cddce2b95cc2cb"
  end

  depends_on "go" => :build

  # `test do` block runs tailscaled, which attempts network connections
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
  end

  def caveats
    on_linux do
      <<~EOS
        tailscaled needs root privileges to configure iptables/nftables and DNS.
        Start the root service with:
          sudo --preserve-env=HOME brew services start tailscale

        To run without root, use userspace-networking mode:
          tailscaled --tun=userspace-networking
      EOS
    end
  end

  service do
    run opt_bin/"tailscaled"
    # See the caveats for userspace/non-root mode
    require_root true
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end