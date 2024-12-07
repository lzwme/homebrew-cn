class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.78.1",
      revision: "c80eb698d5057b04d826b5ae2004d4c464ae28f6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e009c4c38ef7edd70aabe7d26e7f5ddd2de25f1f9aac0bd452aff0c7c239152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "482da1d89933578b318369ad0454a5068ff9ada388e250f3e73c1f6c237891ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "408c2864878f40ea903561ba83f617eda27cecaf37df4ed23042c8e59b660757"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c2c326ac1e3a128789990f7febeb92084aa06101aa086d76d432c7629cdf8f6"
    sha256 cellar: :any_skip_relocation, ventura:       "598283a31656c6780390141dcf68901fdf122e3ab03c13928336438dc5c24753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea39dce3db9207387c76b809470c1cb0b537e4d4d1e8b4e23acc7f238acf43a"
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