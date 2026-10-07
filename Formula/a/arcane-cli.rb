class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "cc99866518c8e66481164d9d0de3c8b3149ce349c31114d2fc2981af6ac16fd1"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74abd07737cba877afbe9eaf28aa91f156ba7e8658d5e37a9fa12ab4171b0532"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "280ac2ca0589cccaed07a68029e2b4186be1a957a3439ea0de7d22f177f1f7ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6aa87fcc66cff4471ab380ddb1ffc4428ad0b65a2ec004db8d40e2c6c76c070"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8bb0daf34ffd29246387ec2047a5b5a75753ed68bba5cf206f0d30c6cd4a21d4"
    sha256 cellar: :any,                 x86_64_linux:      "2e4ff2e0ebe6c588283b1fc6098ffcd94a28a7b24ec51c2db058bd106782d74a"
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
    inreplace "cli/pkg/root.go", "rootCmd.AddCommand(selfupdate.Cmd)", "_ = selfupdate.Cmd"

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