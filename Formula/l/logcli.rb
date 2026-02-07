class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "4604e23a7a91eff7aa299a269af74b6f9021a4d4f396d33f3b7fec1e91b289c6"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d60da8d25eacda73bc9c0fdc2cfc1c8b2fe2b9d61a956092a8ea2ee52fd7264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6acd20d94b97424c1ad11e2989ab907c34d8de43fc64d6fcd2f55ec40e1d6ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1ab847b3581fa03d12a1d9702eb9f2d8d8b854d39d43cd4f7e04271677e3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd229b9be47d977755cceb23e56b667950d38dc784e67a6673c4f732d6d092ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9587203e6c160a3af80ae6108a72d6c08ecb775a631ae470a5caafa3f09c3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18389982345da911f1992e1ba2c14530e890a5de374af47f18f489e6054bfda3"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=#{tap.user}
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"

    generate_completions_from_executable(
      bin/"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/grafana/loki/5c8542036609f157fee45da7efafbba72308e829/cmd/loki/loki-local-config.yaml"
      sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    spawn Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml"
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end