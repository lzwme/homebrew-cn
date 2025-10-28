class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.3",
      revision: "c50fe718222099877069f72e491433b8b217da24"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "092c83a0162f2b4881e3281bc14cfa18e672cd5eb4a2976bfa1c736bb675c988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df00130e777bfbf7f8ed5e05427c1889f2e3e51dd15fe90800bfb0f360bff997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda491fb26e7e9f4454ac25db88bf090bdb3080a2a20b32ae10ddb78eeb121de"
    sha256 cellar: :any_skip_relocation, sonoma:        "037d88537243104979bb37f543e6ee4654109a585207277403fc36fb52cc8f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b629babd305d62ae2fe5718ea41aebde3d767e748126f7b17ab3aba1952bdb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee66bb8bd597f9ce5f128efc354fbe14c0b3dcb2f1a30b42e45cac692b0a38e0"
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

    generate_completions_from_executable(bin/"tailscale", "completion")
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

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end