class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.80.3",
      revision: "bd762b8274a957fe11c4416c6278ba0682124931"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0203c994768ae5e2d07701cf2ffb5fce6ba6d95b9e83dc93c80e7f3687ce26ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca20ab1e09015ef2f1ed66fd8d96dd2252b1d9a2057cd1e077ecd5b80fb88f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4a4c3f6f09cd4b6fa613b699d80bfe9cd6f47894b444bf2aec1be98b00673ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5c8c77831d49d92197a7e650febd0ab802e6dd2d2956a42192841917f5d7cc"
    sha256 cellar: :any_skip_relocation, ventura:       "f00d7ccd6d0c9c4bc9bfc0acd39692a9a07da3f214cdcd20e1e74e230afccd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336b2354ec2185a66bb05e1252c7ce16612fde3d93b1cd029818ca6e639fd595"
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