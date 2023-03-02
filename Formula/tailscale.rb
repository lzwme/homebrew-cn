class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.36.2",
      revision: "0438c67e2517c78feeaf0d9f61ea2a6303dd875c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69bb17b4f1f4ab70c270a21698cb458929092ff269e88d76a3c95e3563931340"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69bb17b4f1f4ab70c270a21698cb458929092ff269e88d76a3c95e3563931340"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69bb17b4f1f4ab70c270a21698cb458929092ff269e88d76a3c95e3563931340"
    sha256 cellar: :any_skip_relocation, ventura:        "beffdde494f7e901e1627ee72ee761b4dd2ccaabe07f8f1b3163522a43e615d1"
    sha256 cellar: :any_skip_relocation, monterey:       "beffdde494f7e901e1627ee72ee761b4dd2ccaabe07f8f1b3163522a43e615d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "beffdde494f7e901e1627ee72ee761b4dd2ccaabe07f8f1b3163522a43e615d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e485a0c7912cb2cae140cffe4e9ea80ad1be218d630851b1f86096810c2a26b"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
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