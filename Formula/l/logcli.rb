class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.1.tar.gz"
  sha256 "8e496f9abc85f7d4fa05efb70fbff419bc581f342574afdb13fd3c4ec33a77bf"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "446597fef97c4ccb90858676f35656f513dea1a2d5dca95d9e6e735c125abd13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d17c2b4fe6d0dd78c9702a9fa96305874e191f1f582cf92f5b01cdf3c0f5bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "420286e8ede13854b7ab81bc60faee0b435010e3cabb19cd79ae35b8a1f54c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f4c4e4ae579936419e114d2b868adb7258de472ad8b7045e740effc65d8501"
    sha256 cellar: :any_skip_relocation, ventura:       "059c7aa26f411b50b31e41b51a68dec5eb806a772e8e06df200bd6d5b68ca114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778d43bd8057d8e1b0fb134951937fc540bbafd74666cd7d63b5a3d43ef80756"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comgrafanalokipkgutilbuild.Branch=main
      -X github.comgrafanalokipkgutilbuild.Version=#{version}
      -X github.comgrafanalokipkgutilbuild.BuildUser=homebrew
      -X github.comgrafanalokipkgutilbuild.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdlogcli"

    generate_completions_from_executable(
      bin"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https:raw.githubusercontent.comgrafanaloki5c8542036609f157fee45da7efafbba72308e829cmdlokiloki-local-config.yaml"
      sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "tmp", testpath
    end

    fork { exec Formula["loki"].bin"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}logcli --addr=http:localhost:#{port} labels")
  end
end