class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "f180d833540e2b1e5f857022fe104e22ea760cf6013590ddbb2099f339c78d7b"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5594950b0c3daa35ac09a4b83d60dafd4f2af4eba32b9d17381ee5fca4a81d36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04f500fe42f50aebaba76ad16e980f8d1214a2ed0f16f99674fd2197e76a6556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78ffdb71a793c1104b43a6c45a13ac8c1fd80dd255c0d00f6f7ff8930ea57493"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e8eafb0ee0fb47f620d7d520e697363f5addd46566d472d462b4cdda9a5cf30"
    sha256 cellar: :any,                 x86_64_linux:      "93e00e84a3b6cd32cea780f1d4872dbfed78c636dd111fd18bd415e513cf5cc4"
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