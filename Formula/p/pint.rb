class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.89.2.tar.gz"
  sha256 "13b586f146ef20971245466ab300b790c17099177f4284ec0f092d9c55df052e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9249f0cf268c59fdcbec7013bcf5720dd2c85597b3acb31cd4eb1873c8f0e88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbfe03cda97f74ec4399da04e8a127576ceb72aad82037d941f6657d1f03e0a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce1bfc8d9ad377df70a51f5b058c27af701855f0f9b7885cd8db58a67769851d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a85547322c5337944eb093f1cac9a4320ab8b880f76092e0243b743fe252a79"
    sha256 cellar: :any,                 x86_64_linux:      "9dd87455606744fe67413f1b72e4912f82e5e602d8cdb6c9bc16cde7adebfae8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pint"

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
    assert_match "level=INFO msg=\"Problems found\" Warning=7", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end