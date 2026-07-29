class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.98.10",
      revision: "36550d57f4a4055246ef7412f4e650a012a465f1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "425c9d6e4219cf983bccbe061da7cc6fd46164e378269eb2a447d2b2f4fbffe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4990a636e8edcd58f21c19ec242c9911cc0683c0e26cabd2474b82b63ef49a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7efeeea64f7c73c4d0bcd8eec4cbaeaa7ce570355548d1102bce7fb737521f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bb52b01feadb0abaa1358dc8b2238299f7c06c3b519036138d9d9c1c11f7f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba584f460e7e1f5f812f4c8cf91ccbb4cf3a3aa869c3f8792ae1df345493ba1"
    sha256 cellar: :any,                 x86_64_linux:  "dca45619ddc80b21d1a37f069a65099a4329b8ba6f84ed8ad5417ce00cfddcf4"
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