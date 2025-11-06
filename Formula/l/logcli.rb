class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.8.tar.gz"
  sha256 "4441408c73dfa5d81f1e26d7b608d3cd943c84132a28f406162b24cbfc2db3e1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb792a47bbad45ac4cffcf78c0d3ee7a4cb1f455f3ec37998e03a8b00354ae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325e4bc00229d74d12ed40871e06ffb428483ada4bac38e3454357098bfd2f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82bf3a2d1ed21374d88685ded28db65e16771bfd037ede5a9d05a0af6a7e6109"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4b6124e660d9539367798d15ad9444753b43c04e5df4ba7a2e941efc06ccd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5df2309f6bad7d2ef4e234d1efdbb840dbd4981b16ad0cf20fa29a6bade333d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4165ea5797444b2aa6b2514c2254071421d0b6d261c2148da4a53092d0ccda6"
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