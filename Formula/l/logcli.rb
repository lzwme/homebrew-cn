class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "c2474f291386bd4fb13c8c585df546cb218cb5fa644dabda2afa6b271a57f2ca"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303d5d2d7de53caa9c284607bb710ec3a8283a99a135178904e0c46f6e1fa4b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2850305d32a391604555adc89a1d21ddafae7f16291f61411811e92051b983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fbfa1af2eb8873f34bd4498f8c477dfe76fd70f626d7b988e37c4105e7ffc01"
    sha256 cellar: :any_skip_relocation, sonoma:        "4102e8f4b23d8f3f86183452b4054b7f715bfe47317cc011d06f12aee8345c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "5609060ccd96a6b7df143d39062097ebd33e4aa27428b08f800c721202d5db97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d596068c87af2fde26bfcfacde37644902fb79bc2275e60c52d8e617748d4a"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
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