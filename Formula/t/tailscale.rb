class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.58.0",
      revision: "dfc5715d9473ad16b132d1b7f4d22e5a607202e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3b77ccfcde62e891f6870735881302aaebaef93f4ffa3e009408cfc0e0e25cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebe4e0c82a02e812cacaa325befe2b15d3a03882810edf6207869499e0c65f82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a05ab043323630a8a27622ca67d52e1b2f2384d3f2bc17ac02928c815e8a8ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b09f2aea56aa30f81af58bc078aea0c28ec3159f159f28c09a80c96863a42bd"
    sha256 cellar: :any_skip_relocation, ventura:        "b2338b9e4978cf3aa1925f0e8ddc9843da942ad529e47d42e1c735ce73ee66a0"
    sha256 cellar: :any_skip_relocation, monterey:       "b69b49969a7d19b8e1623a3e02b73aee7954c0181cb7bbb3158fe5ff4899faf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5208c3f0e37db8b391d9f7c081f029199845416497887c8b1a5e17605abd441f"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"tailscaled"), ".cmdtailscaled"
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