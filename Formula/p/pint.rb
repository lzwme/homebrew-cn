class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "d736cb3282a5785a8189fa8a349928c27438c550030a240f8b61c1689e7dde2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de2b6e7b9871c20738c54ff5c66c9f72c4e2b3f50051a0e398db9e47588d6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ba181aca75a2a3f2229df7df381471ddbdf990150a9cc6a367f955ac2779f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0690ee1b788dea3f2694b3214ed7bc37181f1f8e5f2f12d7cc01a8bda0b2882d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8175f613680a7fd1f01d029d3d199537e1cfbbcb903515eee7683766d8fb27bd"
    sha256 cellar: :any_skip_relocation, ventura:        "526ff14ccb8fbac20135703de7f07588e558843d19be5e832ae5a9e8963e3b30"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf3a985d76367250d6e776a4b814ed6070954c27399db2fc0086941f7746862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86446d3812e5957b8142b754cdb259195c8afec5f1b05b1e8620236bee1a10b2"
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
    assert_match "level=INFO msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end