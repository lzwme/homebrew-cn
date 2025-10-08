class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "776b76f24af45bfcb75c994dbda51d55b5db9ae21a248252fa28400f166363db"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b824293561a860ef1f49e976cc609431876142a1814f4c4ff1a3dc1e8768bac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0457f9b1b73c2fd207bc02c6ba2d0dd6ac9e55d078040e5a5165d53c350d26d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab7704f3431f8d00249f221057cc62e8de3ed7356ea8db5d590b0342dde6282"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6cd22d51e9316c5f130f5995a8e1105c3b724a0012c4e1047e47e224f655cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7f38eb816da9d0bab01905baed3f6204ebf2b2af8dafe1a6c260d921d859b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

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