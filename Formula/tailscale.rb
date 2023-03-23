class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.38.2",
      revision: "3db61d07ca81aea7b86591d1874e48db01b6abcf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "333110dcefc360932e2e39336927387d2bbe77c9dbe7a9ac6163597dfa0676a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333110dcefc360932e2e39336927387d2bbe77c9dbe7a9ac6163597dfa0676a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "333110dcefc360932e2e39336927387d2bbe77c9dbe7a9ac6163597dfa0676a9"
    sha256 cellar: :any_skip_relocation, ventura:        "89916b85c4c05f648f84bb68bb4c887cc7362b519b04ea9d8f2c3a47ab269e23"
    sha256 cellar: :any_skip_relocation, monterey:       "89916b85c4c05f648f84bb68bb4c887cc7362b519b04ea9d8f2c3a47ab269e23"
    sha256 cellar: :any_skip_relocation, big_sur:        "89916b85c4c05f648f84bb68bb4c887cc7362b519b04ea9d8f2c3a47ab269e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5218f9ec3e829a00cbe3f2a3c2f5c29b502129591a719f63719c1c42caeac5c"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
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