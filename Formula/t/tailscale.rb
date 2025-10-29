class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.90.4",
      revision: "68cba300e4903d87f3f315e451fc70e67c58c8e6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27825cd3f6bd927dca6cd252cba4ebad5e693ac6d4dd4074e0a41a68ee08cbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff89f1387b641da31d8c2927613b22191e4709d97abeaf4535e37b0954595c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44cbb83f523cf62e10d204290662dfbf18e34d90669b87ccd3853986e104c2f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a268cdb0144f56f11cb29958823e77181f246b7a5a03d595254b1589b07933bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59737ebd8c0a1da4f5401638e3778a2742014d98998548fce6baf30149743cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e699209021c17b676996f2ea9754b135b0c8af67fb81c1a78baf864cf0119e"
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