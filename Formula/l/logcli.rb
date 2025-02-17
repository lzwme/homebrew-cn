class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.4.2.tar.gz"
  sha256 "37572bf4d444db657d397d205f5998c200233f9f568efc5d99a2b24c3589fbe5"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d247cc0ead66c175f5821f74542b1a703df7b41aea28fc92dc141d73a346b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5095af1b3b297d0865e4e6d9d9af61002b75402079d33b341b67bdb7bda8612a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5cc3d92e2a91aecb7d017782a60aa5eb9e9a4e9a9343eef53fad8aaed22bc5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc09481d8aa59cf9e7007bd02788f870cbef6ac45a886430c9e18c0eb361bff"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d8bbfeecfb1ec3de2f64b7127884d580e1ef16438dadb99a269a9771240799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cada8922177f79549fb0a5b16215c51054c87e71d00ac73ae6c43dc51a89b21"
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