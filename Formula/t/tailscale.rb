class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.68.0",
      revision: "52ddf0d0163276fc2f35ea06974594fac580a6b6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "975806c6dc46a315148094cfa83b2de5720ddd991761cf2e0a95298bbdcbcae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e7a4dc1b6c692ad93ec11ec2a4738f6c31344043a8ad1802a1b26f6f8f3a672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37eb8a0969de236fc8e7d3d2470bde62bf5b464e0eae3dbd24c4c0ba56ea364a"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e329402b8ead7cb715181156dae67af0b79880e7a5c3716c6269a442b405b9"
    sha256 cellar: :any_skip_relocation, ventura:        "131b722a4de55cc7aed3721d8add4b56947c38112e6e4ddf99473a2765864b35"
    sha256 cellar: :any_skip_relocation, monterey:       "afad066b344cc15921dc978b2dc5bb6717f3e7050b5a30ace4f98a570ff91e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d22133d3b25ca87ca15c0437c7010809a66f65a174d4390727e43fd63666f6"
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