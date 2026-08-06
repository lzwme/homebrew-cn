class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.7.5.tar.gz"
  sha256 "e9279bde2721bb80a3c9a4918ce7b707374538e2901c302ededb7c8618d6614f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45e4d1eedbfba33fea973c0843bd4bd9465fc98a6504258a5f174d3287e60f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827c37032e75f870c15aa763b05cca07bad6a688a44e66a11766e6542be8bbc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071c747f26997233380cbfe81d7ffcf3c6138aa565d149c6aa573da68faf8b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "51823e21f1e36245d59de8182d443714e3491653374c33aa09d91f68b7e35814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1c2a34f60d0b26c5c8ec4ec5c2721bd01eacbf2a899412a8d1c025721732f7"
    sha256 cellar: :any,                 x86_64_linux:  "222ab9083c20d07aeccb59a351ea89d510a43974fa0b6c40001a3f49c7eaac31"
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