class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.40.1",
      revision: "d2684863c20404422fe0b35d9dba965359e02705"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f5b9ec85387bae2fd2e8c2474d3069ac7eae1b6eba03981713301c9493e264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f5b9ec85387bae2fd2e8c2474d3069ac7eae1b6eba03981713301c9493e264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87f5b9ec85387bae2fd2e8c2474d3069ac7eae1b6eba03981713301c9493e264"
    sha256 cellar: :any_skip_relocation, ventura:        "5531779fad48509ee0e1af6119100f5b183be7c412dad26f48f426be39c4beda"
    sha256 cellar: :any_skip_relocation, monterey:       "5531779fad48509ee0e1af6119100f5b183be7c412dad26f48f426be39c4beda"
    sha256 cellar: :any_skip_relocation, big_sur:        "5531779fad48509ee0e1af6119100f5b183be7c412dad26f48f426be39c4beda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8229b6669c8def9e7e07ad715d6e27545d010ece0a81d2d499d4a091bf146656"
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