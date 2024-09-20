class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.74.1",
      revision: "0ca17be4a2d5f5c54c9a2c74e3003de8d779c4f0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d42a30f2b3d2615d22428647ca3405c16bc4d350072b15783c80790e2fdb0e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9442dcd477f2380831dd9a8b5bcd7cf349310dae661532b1b5b2107cdef87150"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d6e26d8085c9454e6a4e8f3d7c34910069deee1f466391616d3fd36349e24de"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb32422b432b5ce7c858a4d95cbf07bf199a5d85fcd8d804d4ff54e8e5250f14"
    sha256 cellar: :any_skip_relocation, ventura:       "9ac6b71ac40d1cbbca2686d7e3a167c76bc75c6ee85eddea952c747e1bbdc119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a05fff3ac1b5e39c23fe1c2ba3e7f91e28ffa269b22317ebb8485cca70890d9"
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