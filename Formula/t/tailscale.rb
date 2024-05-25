class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.66.4",
      revision: "e64efe4f777cb5b4d9efd603ad1360a509006cd1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "833978cd44ab99543e149e7b5d6feb489ec34b2148301e63b53c3d9a79d13f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f635fb19a05f5f85156ec1e1bb7eb4499622454fb90180bbff2bce5c423fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0505e6c1446c5605ab58248b30696cd85d8f6593e806fe735b640dbdd368702"
    sha256 cellar: :any_skip_relocation, sonoma:         "a63d3abe58e6f73936c1403f50de43133137982fc03444c575190f74babff8d1"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb9c3eba2d3a83c9685cf9f153f82bf47ae0a4d25c58c3d7498ac9ac08eeea9"
    sha256 cellar: :any_skip_relocation, monterey:       "ca886f84d53a3f54228731d19ab9536bed4dfcb58785943bb0bc0d14f1052ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1c792a3882a37b8edaf62d1211e416a79ae70b5608e18bafb496d6be5f10a2"
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