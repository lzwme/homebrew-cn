class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.96.2",
      revision: "17a4f58b5c457d350b1e357c8b1e3a9e7188416b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb55422ab413d70d6541ba89e341dabea1179cead87b292b2d367f956d377abc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d3b348d1d8735ff59d7321210c36cbe54a8ebd99eac0577cec16262c11f8fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8911e0c7106dc1231ae635cc2789d5a43c1c4f5afdfa8168b4453d06484b06f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "738ee948c77b0a885951ec5095dbce731d8a3be373a4c0aa393c6f441e2d410f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33357bc235d0958dcc45d473be0751c8867ef412b5a4d411718e115be79ae575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa7bc317a6bf85492f9181eb411426fb5c8ecf71fca366bbf86d82697919799"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end