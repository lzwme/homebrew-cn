class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "ffb7f055a86e9f6345b57aca4386529a848b2dfbc7e6f37035d4adf202e92f65"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a6d310cb1ed9c0075365f2dcf224f218db5f97489560505f682ddc0661c807c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30481fd82398fba55c19bdb1ceb961639d6ee941a97fda6aae946a87348a60a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09121664d6e586c32c99296a5e0f01d423184fc90809cdd8f54f4c23864e8e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c917f64d3d117e48921e53a12a1059a864a1256ce72a514259f870db274f28f7"
    sha256 cellar: :any,                 x86_64_linux:      "75c1c0d3a70cf852c9540b6c818966baca88db92a9513b81e470e99c1082c617"
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