class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.5.tar.gz"
  sha256 "4a0b8182eb56344068934cabc21e5ad94e6f39a0392cc805c131529a1ec8f5da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67fea020e71d59f655e064b27d0629f62440fe132788cb80bd7a17fbcee7ac27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f95c4e68c075d7c430c8c0d4f446ad0377f5ba79ef11e03ce93bc09b3e85b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e3e3ccbb5f97e84ea048e570f3eff915bcd0a08fbb432aab2e79bd133cf9d55"
    sha256 cellar: :any_skip_relocation, sonoma:        "2888e160d35381f16d473527d2eed60f955544d15ea20d633019f49aa6864436"
    sha256 cellar: :any_skip_relocation, ventura:       "58d57aebfc514032a75e019eac712ab2411a91b782eaa83a41196a05a7fc2a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6c39a2fa440fb18947de55895fde9debec96c7f5bd6a21910b4570bd29b630"
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