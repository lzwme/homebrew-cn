class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "813621953cae8b9bde473fbe980ca9a261cece112d92da98cd0ea3fe0aea39c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfe4e5b3743cf4e2d4b9c084e1d8605dd527b5ea0b1cbc30d7ba8fc1fedaf454"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08ed9e559b6595b8d83e5856dfa9d433618d463b245a8bd222ac32603a32063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db28433db7d234879b4e3354b8494d0cd5087e4ccf4c3b665ed52c21c0caa440"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf5a12587f9b7349fc513e2b858862284b2f78191e8c261cdfd2c09cd974306d"
    sha256 cellar: :any_skip_relocation, ventura:        "ce6e67a3833c1a05ea4d9aab3467adc9c60a86dbd4f5da084321f13da542b5fb"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec293f6df28dfedb643635c60b1544bc7fe9495d8ec866f18bf05b597ffd570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a62238be7bae9ac38798187fc242e2de21b12c65a5ffc2a1469877b903bff1c"
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