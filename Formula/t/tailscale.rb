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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97a0d09374b7b9cd21fad0aa3bc29341b2a1f60af898b38234985e7aa82343f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6c49216615365885afcacafb0c67e2dd619630ca171fc00c712468aa135a3c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d31c2ab209830bd5d52a9000d21a79d8ee6af9a747c37abd740f11b5650a85b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7668b591b100d6cead540f111064e3362b20ababc21921eca407a8b88635d543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb3450cafb3ef2c19f498278e8c0a5ccd7db0b1201d7b232b98dd240acaec30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434601c5a047fd9acc4654d2e31ba242a424722b13eb02ae81208faec10f00e2"
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

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
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