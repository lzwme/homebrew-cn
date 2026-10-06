class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "022a610f22da8bb0f1206a23cbc5f62e1f1553fb52747388ad5624dc9ec37333"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "873b650d8da9409dff4b1ad93836667315a7c2618ee1e2164d0818356abb015d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "223a5e878637838d8fb374d982f4c2aca0ecefe561f916bde0e4b086be6e8f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3b4b2a6c2704e0ca4bd915bfe6468ab93836daac07eb17969b92967322f5873"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3b554baf1c7449c1be4b2f9f495b172354fd1733d09da654cee89833f7eb61a"
    sha256 cellar: :any,                 x86_64_linux:      "52d5e81fcd442aca6159e6b1e16b85b2296323ee724835f4a2c55feddd1eb02e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
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