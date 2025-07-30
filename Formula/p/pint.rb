class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.74.5.tar.gz"
  sha256 "8b26b30daadc5743379190388c064e981f961ce48ac1d6eeac6da3472ac4561a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb612270035c84103b0f0dcd7b74b7b512513ac25b6c855fd53d10d9655d5e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32602f05a7c12413095844186943b0931480bc6559b4ee782ff3453f204f33fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e3e10120af3998a51a7dee3954548536401dc9cad0f6e30d7597c371a745357"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceede8bdfaed83a594f1d985dae0258bc20375afdf601e5820b4f49d8a91a322"
    sha256 cellar: :any_skip_relocation, ventura:       "137ee6e3925dd67cfb8f5b4525ad813d518ce2fcad31b2f6e2b0d113f364c44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a9887bd54aa4462a0e0cc78be7537345226dba379b317a8f72d5157948d6fb"
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