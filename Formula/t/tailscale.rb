class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.48.2",
      revision: "ab970fe55dcaa38fe9675a948b3c103929d6347e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c8d76163a93c9245df71b7ce1c161626c95339f9bc374fc8a62537ab1bb9c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7ca10464b415f3f7392f154541774811ea955344e27b5cafc6c828846734e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9359076bb26bc24c75576b920cb4b7699eb0db34aebd63b9f4b047695b60add7"
    sha256 cellar: :any_skip_relocation, ventura:        "e73c2e1981bed2268da158b1fe21c1ab5ba6489fb61a8829a4c98282977c1f53"
    sha256 cellar: :any_skip_relocation, monterey:       "06f3edf409db1186c2e6796c1de42a761da7866b1a333edfc8028bfa4e7a7627"
    sha256 cellar: :any_skip_relocation, big_sur:        "559a474f9bffad789118f353a68af7e2a48b72069c669f54d19f72739d4f6edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1071e46e4efecf0481b5670bb81022e93a42e5d1c971a6c25d35d4ec13d79692"
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