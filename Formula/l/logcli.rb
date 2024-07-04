class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.1.0.tar.gz"
  sha256 "e5a7c753ab61488495a765efccdc0f4dcddd8639f5f38742df27e3f43aaa97b6"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05ef495aea5e9cf93a9a3fd9d874ef8eef1294e57e00ae73f988295fae5cccc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "718dab89e430faec7292f45160317337060726aff6d9111b15e27f97fe359cc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd6e3236a49f6fbfeea39ceaa9e8186c27fa2a5b1d7e144aa1471e3d8440f33"
    sha256 cellar: :any_skip_relocation, sonoma:         "f273da771419e83e43aa4c66a4be5c501c53c7b46751fcad5237ab34225e792b"
    sha256 cellar: :any_skip_relocation, ventura:        "b4df2e3b1eda4553862408f5018984f1a774c2a3ba2d85679e99a42ada0098df"
    sha256 cellar: :any_skip_relocation, monterey:       "9f35fe4fbe0ac8ff0a8937515d68099bd5949c5440aad8182fd9652fc4b917a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4761f1d23e50c5c1c5f0c2a793e63c4f5ca4ace5400d6a5b21065d94cbc80aac"
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