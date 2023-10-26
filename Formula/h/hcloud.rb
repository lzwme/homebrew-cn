class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghproxy.com/https://github.com/hetznercloud/cli/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "7a92722328fe5a945fa3554f47c2a1f736425edd97bc983edeaa1412b097b14d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e4047d9c8dada9640f9274013fae9351599f0a8aa92e6a76ac89e0ddb9f43dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5df8257024c8d2c99c0f1e69034d433255770959c996ad360e56f05a5e26cc3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2f4207eea77b8f49e270dcb1843b06fa431f12c26bb47f3b5548bbf6c15841b"
    sha256 cellar: :any_skip_relocation, sonoma:         "39bbce54cd61de7b97b554935c6d80baf35265dc594ac3021a1d1dcadfe2ca1d"
    sha256 cellar: :any_skip_relocation, ventura:        "b623b0b244d73842e8da7e5b66f41bc062468e6336ab6557cd3dd09bff1c0405"
    sha256 cellar: :any_skip_relocation, monterey:       "ecd813560d2fa4a305487d558d3d12e3234a4f55ec7e4861b9ce25b9cf6199e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f70f8bcc6e4e58d96b8c9062562af376e8ea22a0c12525c1de76cb019cc96490"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end