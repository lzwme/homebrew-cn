class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "a3ffbdc68f3481444c16a7733e4640718af502bcef25d592e77d03da388c4aa1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5db7dec686af3c235637f4a5ecd773b1cd2a09b504e6e16ab1db0c7bb26457a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e015b6382b6e4f8c5410e6bbdf510c079da0d59f0b023aefe7fa5080981fcd42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa4d6ecba4bc86d6be20bb82f5b822121f5b8bafc930ee0755c48eb2b665220e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7b57f2fbdf832137e6f37983cf5528cc0b7920c2e5d2427e7c7576896598f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac34da9803c9fdd0ae081f752cbc6f45151aa6796f1420051b7b301c4613279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef1fccd4a3dd79540b3761d7f2c4dcaf57b6abab55f0eea84d5427656379d3a"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
  end

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

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end