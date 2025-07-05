class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.74.3.tar.gz"
  sha256 "b463ecf811bc6e67a3f8cc6793963eb4d917a8dfa6f3e79e9c8a8c8fadff84cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac9d4f188ecdefb61038161f83177cd6cdb4fc1d4540f1e2de728e8a21e39d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b63a507445db25353a57fc999536aedfa6d183cbebf0a2c032695d8483ddf53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbd7d7d6fdf51ae084e5d06aaa95bec936f3b10bfd3962361dc6e742a78d0405"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b4639dca86f5f47e5e3bce8a9636e5c3a1f205ab0f305179ec2b2acd346996a"
    sha256 cellar: :any_skip_relocation, ventura:       "3869f21717c2d1a811f95c5e601c9d70dffa42dd52e017d4b9df4d7a6a23ba3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555dd712b8c153d4ca2f644c8aa5485a730a121436a41383b1a6149428459a21"
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