class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.38.0",
      revision: "10d462d3215547592f4a30469690068235e2d032"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a6391bf7363010025ae5942f80f39135c2b174099786b0f4b7a8b1785ed7cc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6391bf7363010025ae5942f80f39135c2b174099786b0f4b7a8b1785ed7cc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a6391bf7363010025ae5942f80f39135c2b174099786b0f4b7a8b1785ed7cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "e47b3ba52f85e48f786fa7736590703e2d39c753b77335f3be2bda61155bc59b"
    sha256 cellar: :any_skip_relocation, monterey:       "e47b3ba52f85e48f786fa7736590703e2d39c753b77335f3be2bda61155bc59b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47b3ba52f85e48f786fa7736590703e2d39c753b77335f3be2bda61155bc59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a378bdbd029b92c94b6ef503b09e120cbb20ea4b18840de77ec2d78fb1f5f1fa"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
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