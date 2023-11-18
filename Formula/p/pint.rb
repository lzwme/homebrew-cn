class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "bec72c4b005cf24465faa328e3b0e49a5abe35402f9684fb299e64d011ea1c0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ed7c3835fc03d7db3803ee62560430451f07f09ca76b9af4a0d81ebd2e10046"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf9a4fa5dce97851b3dcb5657718eb0e4f00eb6694908f96a58403e3df185532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5ca8401a0dbbd417916f372a288b25c42a532119a500fa7aaa107a93f4590b"
    sha256 cellar: :any_skip_relocation, sonoma:         "92144f14f5f38107969afda285ab218742f8f54ee40b727062691901f26123c8"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad569557efe7755af00a5b3d1cc2ce7bb5fa7337f726da55c0c63eb743ecf64"
    sha256 cellar: :any_skip_relocation, monterey:       "bc0c1500a0a0425ace2dfcb25f526e73d8824fdf968bd7a9a060705be8cfb98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91cca6c447cbad4fa608ac17dca01a4909cf6a6fcf7cbc69a79307772630847f"
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
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=4", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end