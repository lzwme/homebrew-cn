class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "f60ab1605202fff9f87a1a82a6e744701a93762242dc529fb482924d6c9c0c41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc780d535a8e9a7a5eb61c4d346d770b61d61b1fa97f4559599f65845e974a61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55a5d9f1cf54bbd224401881d46d615a3fa5ebc2b7b6b921a7092cd015d44360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6debee7992b822ad1fa61c1e0dc8389c95e168665bb8ec36a4e51e55d5a3f6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8e8f4d6788ee35349e3832d59e214154e736e394ba8fb2c18b2ffe290ec3f34"
    sha256 cellar: :any,                 x86_64_linux:      "13a34ec7ec6446a3d44b2abed1706075aef6c2e523a5d3f8006b61d7bcd1c602"
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