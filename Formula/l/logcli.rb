class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "4deb052c2bac06b1509298d232c83740e71040f4e6c6c823329d3c44fc5c8b64"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d62f83d06600ca9900098c738e6c5ec8ef6f608413bd58c05d5fcb33193b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2313a69ad835bbdec291d8975cb4e67afb76fc98c9460f8bef4ec584c8618f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e18eeee2e82a09573b7b26d2295b6ec6db860dc0068374b23dd17fc93b4ff467"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fbaf2de4300b1d257b3664d572c97158138a513e6dc98fef147de62f6cd5d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008534be5e7a1fa47927878e3d162040220eec8b3eda3878e10d080879239462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a56969467b9b07a1f4c7e5882cdaa89d0ec29d973cf61d9213acbf66320a19"
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