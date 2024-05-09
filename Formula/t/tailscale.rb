class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.66.0",
      revision: "e2a0fc0bc8ec242e5c8f3d7d0eee67cd3441b630"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb17a6f2df21e85c7c9a564f145faae95da2abf8039e97b45c5b7e35b6504f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73178c7ea58266faa4c5c1e417c72eba8fb53299d5d78260b41b89bbe04a22d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "826e1a6e8bfe64c5d98e3b88bd4b54a78bf2c22d7d8d2f3946408302cba7094e"
    sha256 cellar: :any_skip_relocation, sonoma:         "93a510f42637051a5595f8da3dd7dfe3764516e487d2b59aea3884ef3bbb2ad5"
    sha256 cellar: :any_skip_relocation, ventura:        "59b7864637e9cebdb92ea8e85ef0035f2951106e737cff4cfc149d4b93b2a228"
    sha256 cellar: :any_skip_relocation, monterey:       "269442e6e07561435c2074372a957b7e6898605bce72fe38773971dddb0bfc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a715dd9b752643b180e50604eac7a4372895110583e0b71c8827f825174226a0"
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