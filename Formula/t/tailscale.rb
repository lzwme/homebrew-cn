class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https:tailscale.com"
  url "https:github.comtailscaletailscale.git",
      tag:      "v1.74.0",
      revision: "2118d0cf419e6c7710ccacbda47121dcbe1930b1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "640055e9ce3df887ec55d1084f5847d42909ddebd1f4a9581645317d61ba5f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "960ed09908d8a248f8d8148099ced57f665dad1a87d54eabbc955b0cd5a92085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebeaa84a277b687ddf5744563d63da73bd18a5d970f0823ac54d04a8a1577c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edfa50a5a79a36c05cbaa2f40410d5aef918a7b1adbbd215087629c21e4dd6d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "62bf00e871651ab63d6c9887f5480e764f714b64333eb8dd46419c5f7949c466"
    sha256 cellar: :any_skip_relocation, ventura:        "796ee1f71e67dec8ed366bf9082f7537a08eb480d5e0ecbedfb3a8124f859a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "66254ae321ce044858719e81fc3f7d75e777fcc21f46c76bbb90381b30e868d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3caffec11c99b7c5a4c2339bb1c37b8afdb07d9cb65f4e2c4545b7af6e90ca"
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