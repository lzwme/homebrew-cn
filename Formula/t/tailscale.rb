class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.72.0",
      revision: "aa448d5a9985378af04966c6d7aec8d9f4a166ca"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c30dbff552783594a908140d48987dacce2521a33fdd765912f006cda9f3a099"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8caa099f5ef3a7037c0c39c1ed2542081a209ad91fcf4c0d9a4d5a8a7ca930c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1296ae59a1a9dfd560c5245e8ae2baa9f4f821335f4efbb9391642631396c7b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccf0b06b42c810e4d07dcdb1ec5b37de3b4ac80c3ce9058ee9db0c4c73c290b3"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4f33c8778c61a34a6b8be22d961628a20c47f4607bca7d326011b7c5d49b85"
    sha256 cellar: :any_skip_relocation, monterey:       "040257ef4d34a20e045578eb3c632ba51ad00de58224cd29f448daa9eff50c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fbd52b0f74547d67595634c89311e2f369f3171ef155d4448e8ba4809801f8c"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read(".build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.comversion.longStamp=#{vars.match(VERSION_LONG="(.*)")[1]}
      -X tailscale.comversion.shortStamp=#{vars.match(VERSION_SHORT="(.*)")[1]}
      -X tailscale.comversion.gitCommitStamp=#{vars.match(VERSION_GIT_HASH="(.*)")[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin"tailscaled"), ".cmdtailscaled"

    generate_completions_from_executable(bin"tailscale", "completion")
  end

  service do
    run opt_bin"tailscaled"
    keep_alive true
    log_path var"logtailscaled.log"
    error_log_path var"logtailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}tailscale version")
    assert_match version.to_s, version_text
    assert_match(commit: [a-f0-9]{40}, version_text)

    fork do
      system bin"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}tailscale --socket=#{testpath}tailscaled.socket status", 1)
  end
end