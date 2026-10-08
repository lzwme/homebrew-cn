class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.104.1",
      revision: "9a522a9786c97eb7910c01ccb7bd66557b04c910"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e13d99076130f56f78c6564909e3c20984490baa555f4d1ecf8900885c084247"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e113e26f619a4269d86fc6fb6afc6cacd12a1bd7d9ff02fa3c6af9376b8450b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "044fb0fee67177f26257c2591538f6e8fb9a1f42bbe9c82c1d7ade8ba4574a0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "caefb82c1902121bacb7c1c05b5f3dff75bbfb6cab27f7a17c1c8137a1b7c84e"
    sha256 cellar: :any,                 x86_64_linux:      "0ef8d404db403cc729f0d80e025398a00e77b951ced760a0f34fa90da8bcccff"
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