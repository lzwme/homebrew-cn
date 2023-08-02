class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "a046686fe0479cbe03c5d4decc24cc015078051550aba30a32d89b702faf88b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c902e061144e36db9a1509889dbd0d6cef40b39695181d396677f0afd9bb01d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c902e061144e36db9a1509889dbd0d6cef40b39695181d396677f0afd9bb01d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c902e061144e36db9a1509889dbd0d6cef40b39695181d396677f0afd9bb01d4"
    sha256 cellar: :any_skip_relocation, ventura:        "75428d292e74a509a18cdc051fc0af02313b6bf98e05adbe83b58245ef48bfcf"
    sha256 cellar: :any_skip_relocation, monterey:       "75428d292e74a509a18cdc051fc0af02313b6bf98e05adbe83b58245ef48bfcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "75428d292e74a509a18cdc051fc0af02313b6bf98e05adbe83b58245ef48bfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07ce3dbf0352d69ab05a0f0143376356203376761f6f617253fd13596ce3afe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
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
    EOS

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=info msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=info msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end