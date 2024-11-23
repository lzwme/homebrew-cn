class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.3.0.tar.gz"
  sha256 "b36148586da9f8b58dc0a44fb3e74f0d03043db2fcf47194bc9d145bf5708b3e"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "779809e2144d7d5c227d302b26aa68c65156356986d847927073443ab657ceb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b7b847c11f64754f433f3d2922985b6b977be317b0efeae25682e5c3ebe9f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd926cd44a8060d31ce97e09e15139eac2bc6f3ce834a9a9ae4fef73219e693d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dded26bd2126e0365e05ada941a7a48fc14b02ae0a88fe2bb3d6b1fca5b958b9"
    sha256 cellar: :any_skip_relocation, ventura:       "f74e6a2e847d994fb153c209c1975bc1f50d39a38d1ba5a6ac6832e6b2283c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0494d59c949bec4ea9ef32426faa264b49a32676baf04e2233bee163352b0bd7"
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
      url "https:raw.githubusercontent.comgrafanalokib286075428a6cc7f58040bbdec6c81a97b626852cmdlokiloki-local-config.yaml"
      sha256 "2526c97ba82915499d134d8fb6f3dad2828065531818ff94798b36cd9a59e8e2"
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