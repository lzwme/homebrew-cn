class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "302e11669a07c49e4d03f6982a3905a070b42ff336762167bfa42d93fa61faa3"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a23a29f26a7a17f297e149f1f6ac85c0e42bcbdb3248e3995487a530a01362e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1071fa3343e55100de689d8c1eb79f04e86576345150e8c33639a832ecd8917a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f864d28b7648b39348c32a49584061514f7d2a62cfda2bbde72f3d9d717caec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c2bd8e1e3c60b3ffc3946d062991d17c7fc0f5888837784d9d917c52e6dc8dc"
    sha256 cellar: :any,                 x86_64_linux:      "3406ac1f88a8b09caa19d965a64ad7dfb0aa44653cea5d9269b534dfdb42b389"
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

    output = shell_output("#{bin}/arcane-cli --config #{config} version 2>&1", 1)
    assert_match "Authentication is not configured", output

    assert_match(/^ENCRYPTION_KEY=\h{64}$/, shell_output("#{bin}/arcane-cli generate secret --format hex"))
  end
end