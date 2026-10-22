class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://ghfast.top/https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "ffe767c2cbed06ec783a8853fef6229981241240667bd665d099c603e504c0a7"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1da6ef49ea31a79989ee9c2d7be5d355c38567cd9ed48c58bebd9b8225142a78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dcca2832619a300db7a60680c58f3a2eb3533b7caa5c1034102615c4b5a3923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8704cc7b3ae5be5bc2689971d2f3ffe4367f94322477411c210ad89b240116cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3a12a4072869d61381e6d07a470acad501f2ac64876bb7176ab1487b5a772b4"
    sha256 cellar: :any,                 x86_64_linux:      "75e52f5226376b5a6dc5d205f7fdd7ece64d700b77edb5187c3d5f058fb7cf06"
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