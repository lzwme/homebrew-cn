class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.74.7.tar.gz"
  sha256 "97a6ff5ace0f571b573b22242ad9929c0e66118a75265c614f1467e9de58807d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84f816c57a122abbcc448a4f3e7d57e02759b6186a88ca4eddda6d6db5a5319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729c3077b191fd35987faa4b8e75c9359a1c9d74446f5cc284e00655ec25e2e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a91cf718c9153c2aefcf4cd63770a04bfceebc76166c2a13759b08357009055c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a20d03359171387b10e829de85ae82fa46906f6ad02e0ebdb2d73df765a416"
    sha256 cellar: :any_skip_relocation, ventura:       "492b089e898590b29fe2f010d09cc6b99fb24d17767468e574e70ad9764e5c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2fb11f69fbb1aeb899e9d356debc5fc0e068dfde4c81cc569e7f8e192e3aa64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
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

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end