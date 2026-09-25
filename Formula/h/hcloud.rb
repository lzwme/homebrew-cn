class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://ghfast.top/https://github.com/hetznercloud/cli/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "0bd434b8a997479ae0f3760903a52e3df8ef766a6e7a335bedc2ed7e4267cde2"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "371b28bd4bf6c2bcb30b5e7422df575d89382b01766a88057b56852082fa66df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff0620e7c85bd74b34dcabced13cc77c57ce55a4913a9c9a5deb4505ec6e08c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39f498fa78a17dae85c7bd0ca512043950aefedf75c8524eb622d88398e9e2fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "170e2624d1aa508d41ec3a8761782688658cab83b85e797bd9bc00e18169ebbd"
    sha256 cellar: :any,                 x86_64_linux:      "7c832a28a7e8c45a7fb5c0f0e13283054b652fa2ee8c25f8e1f5e9d46dd4a7b5"
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