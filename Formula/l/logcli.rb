class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https:grafana.comloki"
  url "https:github.comgrafanalokiarchiverefstagsv3.0.0.tar.gz"
  sha256 "ef44e222086dc2e580394c2a1148f7c0bc5c943066a0d18498f2bf6e64ef5a1b"
  license "AGPL-3.0-only"
  head "https:github.comgrafanaloki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05addcda41d0251eec22521f1157eb10c23b2d2c167f5709185b36755d16140f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9a3dcec90e9f2312614249a301547f2450ec1b0b61f40e8526f8e7af0aa9d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7bf2ab08260b526efbdff38c6d4096119d6c164d393c8c05434ea6ae96201a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "179c7ee9448c31f9ad02c0b806a61d3eaa9859528c49107bb695759d55f3815d"
    sha256 cellar: :any_skip_relocation, ventura:        "16f7c45d9faa162fb361e38687489fd41c86a2073fea9fe33b134ea7bf203c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "de223c7d4c21b5d2b80ef8092c9495eafa9ed723fd3ee816665ab4d296ac32f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d93f9a44c9b34388261ea118d50cc9754dfa56cee4ae4c976b4aba004f70f8"
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