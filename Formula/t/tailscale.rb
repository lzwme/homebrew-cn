class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.102.1",
      revision: "3fb8edada1715925e592493ae77016952866a202"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dd44bc166077b96bd3b594c597fcef7290470b9fba978320a97e4f4c2f4aa8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba157cc903080f33116f943a9cea396ba5803a5632f6681193d05018491515d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0929f5ee425e461d8c6631fe351a288f845f59f84750b1126eec502f4e8243d"
    sha256 cellar: :any_skip_relocation, sonoma:        "18bf725f22b5b701bcd7d0660d6adaed5a05e6f387f950ef8697a47afd51160d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437e7e1c3b815e4f68085ec77cd3c72ba8b82d2a27c0e1960a8ccd45827ccb41"
    sha256 cellar: :any,                 x86_64_linux:  "6d13040765931401495b8ed1e7bbf04a881f34fbb03fad97e7b423551446f353"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

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