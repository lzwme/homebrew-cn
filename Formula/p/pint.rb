class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.74.6.tar.gz"
  sha256 "bc240b3540c721bd5fa3ad71a623bd0bfe5f58b513a70a6866942d3baa7dfeb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775a680177914ba85a74148658b7a371565427c6df77b55f47af712a97399440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca219285a3efeb90b7efd6d19c6efaa3d6e82acf92f248cc7a6e4e811a6981b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7435bd3af92d0e92abbd0650a00609a0f4ff2486105a22914bbae191832a9429"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e4806f9b07bfa9019ec2bb71ee4a252b4dbccd9e1eb322af6baf830f7637b7"
    sha256 cellar: :any_skip_relocation, ventura:       "9f9969824d1e57d2646cd49e5098ab3f3d610ddb3585b708f0159b1338a2a0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b1178ff54883beb9bea10720927128bd39e532ddb9dac76199f3ac1d194e93"
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