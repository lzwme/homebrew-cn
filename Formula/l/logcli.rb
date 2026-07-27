class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.7.4.tar.gz"
  sha256 "22edd28b032b8c976a8ad971f8df378dbe614c39d0a2ad9663e629f4e21bdf37"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f21b99c9303a625f1633401d3f2512494e5ec84fe4e6158689f452272a4bcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1840756f5c85e87013598687ebaf7c0dbc4d4adfc5abef6e1d19ebc64f095e8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af85ab8ff1feba02ae1177e7050ba0b4122502b7934892f04dfeed81c56fc4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd396ea2497b69477ab2e6e3859d4cca44a29f594ec588ef2e82f1291f123581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f707acb91401537fc1100cd9cd201a6a962b29aa424afb5225b898889588e47"
    sha256 cellar: :any,                 x86_64_linux:  "c8e753f38add419d86739a7692b3f4b32b333d0a5702a92e63c73844288dd5a5"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
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