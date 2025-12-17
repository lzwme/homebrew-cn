class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.92.3",
      revision: "9a08e8f1c2021d5c85895e660cf01d8bb1bc9df0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b522802056b79c93db39396c706b98b2465890e43bce9009d5554b3d8016844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7670a838bd39c079434fc34020846fa2c950b286793811414da740958b9b8ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda881eb9be29e8e4e234225ba8dd748d58bc411337fe8a20265ea0995eb5775"
    sha256 cellar: :any_skip_relocation, sonoma:        "8268cbff3181971301093b289d699a67db989b873aa1bfa02563037f1b307b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b484bfebabf3295a45f229b319ea3715d44e0c72e8f9099ce8eabbb9aa9c0c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1770121c122e062de034c24fcba003349bedb4a953645fd0064ee039428f2bda"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end