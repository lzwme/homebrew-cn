class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "0a1b9a001ccde90cf870118ccd02a5be4f7ededbac4c8c2ff556f0380cbc559f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3548e1dfed84d26fcf6061b61eb8cfd90b2f21d4481d94d348a3d746571247ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a949ea81d669d5e5cb8f2ed67a8ff68a13f94fc3b3af75309258e04c5a4fce24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4154029ee5ab7652360e8f65960feede2ea3dcb80d0c7eb0fb58adc771bca526"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6004da2df9341d2699bd31c73ea4e6e5c621d759d29874d4e4016fcf186869"
    sha256 cellar: :any_skip_relocation, ventura:       "8ae77793be39ae46f2b2da5127aef5d5f0dd4afcca7325a2cb25444caede2edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb4a48f45395cbace66ca39a70a9538a07da238d022923ccbf8277f83df4516"
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