class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.72.1",
      revision: "f4a95663c8995b0a2362abef64ee91eceec52228"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6ed8ee88d30e8123f80e17c15494bd279775058d926200accc7f9b4fc6323f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2efa20b4f4ab0de3638a6aace71b2a2cc538516459c941a426b6b05da96497d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e55c1181b0519cb84a2b16880c1a1058039fc7f05a9142829acd3b99d3985ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd5458b49feb2fd28b7103c499f142a70138a0f7ec827ac0d16491d9084fd71d"
    sha256 cellar: :any_skip_relocation, ventura:        "bd14ef88b6f8c43bba7aaabfe29c83e16f32309b3cb5b3679d29628f889a210e"
    sha256 cellar: :any_skip_relocation, monterey:       "869bd6e00f5da278932d22cdc1ec6fa6a92980641c907fc5a63973d2aa563f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a7fd3fd1b17e496f5103cfa86b96d10f6a007f6262132118857992ecd0aa23"
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