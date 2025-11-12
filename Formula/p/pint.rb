class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "b80fdb1fa69bc027f41a56c6681900e15e181257532e002a458388c52fdf5599"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec4af30eeb0d066e4854c261af87b634e4262a4478458d351ac73f380096d09c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9009945764c2c56224ac7dc06108f1862ff6bdb2548a6be91460982c08f3ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb99691d6244958bb1cca3bd9fa1e675c0a64ef0f8b5841785d43b7fbaddf1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77f8d6939d3152ffdadfa74e208fd6e3815c56e946d7b7e025584208e474b20c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3805965241f0979661e01cc6b626c3a9606603d52b09c81ed64c754a5d2d243c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9ce5b12587f50933789598545cf19e9a956f9cd83759fc7b79489b4e1638c6"
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