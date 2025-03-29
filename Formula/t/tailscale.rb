class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.82.0",
      revision: "6676b1261e51e0629553ca06b22e6631f8641100"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c649d503dad0bd0fba4b514021ab7cb4568cf4f069af6d960fadd1cdcf567d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a44ae1f43373b8a3bf7f92a797c37c296f132d65a06e1cd1ace07f2d396de4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c698273f5d29dced1c0720b502c543255921b2028820c6449c7351a3741b1dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "314fa90af2a1653131074ff19e1a698b4fe5e7f8dee2e218fae2b8198ab4499e"
    sha256 cellar: :any_skip_relocation, ventura:       "03af57d52043cb29e2da028f3c4c98cd11187d14e7702120c997d92546bf7bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1084b092dfd6ae7c647384e39e6ac1f9aa666cb59831c54c16d0d8e6eb4a1e"
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