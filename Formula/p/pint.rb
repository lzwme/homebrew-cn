class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.74.0.tar.gz"
  sha256 "45db4275ab140ed1c471cc82d4ce381cbd3c6240be434e38b3e8342d4dae21d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d839130299b95376747cb825e4c70da7394cb80f60d52b027feb04245df880fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b3a8a85046b8af5354e0a2531e4c26afd96cf03702c5c32f5a066cac4e507a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08088219645a6772be71bd03960f6231a57ba379490007fbd666895e08e006bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d95494349eac3444b98468b8eb173c99670b2139d64a3416ef28273727fd36"
    sha256 cellar: :any_skip_relocation, ventura:       "6188c43f21fbfaec5616248981629607900ab6e46cf1bd31480cd3ff3d374609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1dd5aaea5c6f710b6b75e50655d7089639cfb49fa8b08057f0aed62211320b3"
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