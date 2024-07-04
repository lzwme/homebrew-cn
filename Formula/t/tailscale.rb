class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.68.2",
      revision: "c79c500c7e93c8e416c77f85d106b04a4aab23ab"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14597e4e17ae69c3271fa7824c5afb128154f0dd0cb4ab0fc23428ff4a304187"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df5cd2ebd47bf0f69fdf5957fe73d3df45d74b6b74d747ed85cab59b0ab72e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64aec43364f493dcbbf6eb1d44c97a72781f1d06942ff6e2ea108e850c3f3e34"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea59e406983cd2d83216fe3f4445182564521f359fd2b24d1b2223bbc9c0e2f6"
    sha256 cellar: :any_skip_relocation, ventura:        "6142412ddcf2cb51028c41d93395fbf993671c568c804b6494b92bc1926dff04"
    sha256 cellar: :any_skip_relocation, monterey:       "4957b6522ea50d2203fe67e7f4f27960a917e6405f97483d65ac7f2fe25bbd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34fc261aa45b10a293f5241d86c41e7b93d3ead12d224f4d4ace63110f0d2785"
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