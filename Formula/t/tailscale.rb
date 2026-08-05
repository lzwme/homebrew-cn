class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.102.2",
      revision: "eb67e5dcbe145d63e1128b9b4b630f8a82da101f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af0259bdb34cd9fc77385fbbdf30f8059617a37a095528781e11b74f4fc1d37a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0ffecdef7144d1be93391d86d1819b81032ff9bb95bf08f90773d21b261235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05782b5ea4ce310458ed4ab7af7859d7eb9289462c9c4b79edf1c6c14c601602"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ddb89776e170e738bed44ee92220f57b3e54cb4aab97a5b40fd349d68eecca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b407aa6d6d4ecb96429fd0ad0dc9552ecbb72ee3479e1e006a67394369b2772b"
    sha256 cellar: :any,                 x86_64_linux:  "436fe3e2ab0138ba7a51d2322a3204e625bba5b7f7527142c8bbd302af5fa900"
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