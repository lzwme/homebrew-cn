class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "3a5ed5953472d8c313a0ea80fa9ae27f39135e5520b8bff28e90371a3ece7a6b"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65bc2d6373391b127f17bb09632d411696d9cfa882525d23ed9e1cd41a7015ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65e7761e8536e83f560d9456dc49b737c9e2b6a8bf93f6de958102b378e21b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95f0bee40ef669fa457ae42d262730685bda8ce0a09e529436d334180eb826d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "90f8ac47a71028a3b1513405db1a4edfba2519d81cb92f5907f424961c259882"
    sha256 cellar: :any,                 x86_64_linux:      "065d6a7399b35960911e47399b6b08f1dd599ce8c8e0d78b509a24965716ae8d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # The top-level go.work also pulls in the backend's dependencies
    ENV["GOWORK"] = "off"
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    ENV["GOWORK"] = "off"

    # Homebrew manages upgrades, so drop the self-update command
    inreplace "cli/pkg/root.go" do |s|
      s.gsub! "\t\"github.com/getarcaneapp/arcane/cli/v2/pkg/selfupdate\"\n", ""
      s.gsub! "selfupdate.Command(), ", ""
    end

    cd "cli" do
      ldflags = %W[
        -X github.com/getarcaneapp/arcane/cli/v2/internal/config.Version=#{version}
        -X github.com/getarcaneapp/arcane/cli/v2/internal/config.Revision=#{tap.user}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"arcane-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arcane-cli --version")

    config = testpath/"arcanecli.yml"
    system bin/"arcane-cli", "--config", config, "config", "init"
    system bin/"arcane-cli", "--config", config, "config", "set", "server-url", "http://127.0.0.1:3552"
    assert_match "server_url: http://127.0.0.1:3552", config.read

    output = shell_output("#{bin}/arcane-cli --config #{config} version 2>&1")
    assert_match "authentication is not configured", output

    assert_match(/^ENCRYPTION_KEY=\h{64}$/, shell_output("#{bin}/arcane-cli generate secret --format hex"))
  end
end