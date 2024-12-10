class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.69.0.tar.gz"
  sha256 "25ef7e683879d4baf95def0cb5d65651e8174814773850b4d8d00f8cb7b2828e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d07400e78abc4d7b58c7acf4414f5328c3145c1da776a84e99c8fa6f452e72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d07400e78abc4d7b58c7acf4414f5328c3145c1da776a84e99c8fa6f452e72d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d07400e78abc4d7b58c7acf4414f5328c3145c1da776a84e99c8fa6f452e72d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebc5e26727ed549e96709c09e40a72aba9bf552dc4528ceb7b30b89b7c41ca14"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc5e26727ed549e96709c09e40a72aba9bf552dc4528ceb7b30b89b7c41ca14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eefb3b4ba0441f33ca270101093f47d006367f6bd0c3a200574df6408698e0b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpint"

    pkgshare.install "docsexamples"
  end

  test do
    (testpath"test.yaml").write <<~YAML
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    YAML

    cp pkgshare"examplessimple.hcl", testpath".pint.hcl"

    output = shell_output("#{bin}pint -n lint #{testpath}test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}pint version")
  end
end