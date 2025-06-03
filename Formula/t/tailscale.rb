class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.84.1",
      revision: "72ec2811bfa0157ba406f5631cc5d7c1a3b692bc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2a9edb0fdfb476cf3018777d8be28e8552d9fd82306a04d8c02040917f86a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bce1cb49ee7e67904612481c39845427d36d801e144e104e614531d58bb5c16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37dda9e88dfad05d366e17e287c26ef0370705aa5ca3961b1845518c5f5b6393"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9fa65b1c5215ad6fe4aa5a16f57e58e993463dc5a6286fd2ecc12fb611e9b7a"
    sha256 cellar: :any_skip_relocation, ventura:       "0c806a90c453e7a2d00613d5350496a4444196a21f9debb0a014b704c7cbf9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb8cad6e15b2ce9e7d8f5f491d3dc6420218b6262ea63fa00129df2e0b4d6ac"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale"

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