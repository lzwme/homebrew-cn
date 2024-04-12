class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.64.0",
      revision: "78dc8622d7e19082d94877bfa12a8801be9ee9b9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4037679edfc55f83771e58664932fcee87565617d82cb1e01621f84a5d470c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2766ecd6bd9674c2eb84fe420444212010586e984394ec15cb483657d6841384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c61250714f406fe0cb05c524dc507b40374c8207a3d62b593ec9a389003303"
    sha256 cellar: :any_skip_relocation, sonoma:         "8276e9ccf53bf6c13a6099674b96d694bdfb128fe95847e5cb1f9a7bb17fb037"
    sha256 cellar: :any_skip_relocation, ventura:        "3efb13e8d0bfd0f791b29a97b310c080417095aca7446e1506ac40330f370b41"
    sha256 cellar: :any_skip_relocation, monterey:       "da27fc189bb31511f859826bc6ba4e38e4405d893c1848ae60f5320cd61b8b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1cbcbb70fe374871e03d0730e914c122daf6f009e9cf4696f61d699f1ed258"
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