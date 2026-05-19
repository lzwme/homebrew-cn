class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.98.2",
      revision: "34c530668cb05fa60b3d707a44b70460344789ef"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52e8c2a5fa21156598cb5db1a04b11c5663aa46f5ff9a9ce1da0975a5ae7f83f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a567b06b10c328373db5643603c622bfc5220fd35d1562c1d356bd69c80919b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce208fa0118ad4d5da13823a456a97facbd3b2b235ed13c9e8955cb8c5da450"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32e2b640dc6b608445ebc4789950980dd80e62fd8a7887ded0e3b799b65381b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "478ed9d8ef1c96dc6f1acb8332f2d81c9ecda7b50aedce32aee197169aefc97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd79f0e1eafb2da8ce6c46fc45fbbecc9ddd89794ccb261dd608b582300eea8"
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

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end