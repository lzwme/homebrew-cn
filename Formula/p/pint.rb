class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "a15f0dda2c9f19e9ab0c9ae01c048c208baf08ae9f6899ee6fee7a303c09e9da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a489fdc1af24e46cb65da918a1443bea3a8282fe175e57f35c1fd35e288596"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b3a3f452f6b8e4822e747b516aca2468522420c94a4295147d2aba0be51a808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65f7656d32ff6e37b4b4defbb7c2ae9ff4ca7c05e65207fcf50957c2007b6df"
    sha256 cellar: :any_skip_relocation, sonoma:         "52e515e569220a7e9d5599aad19014396d1ed0ad3856589c35ad0a6bb5e0d157"
    sha256 cellar: :any_skip_relocation, ventura:        "89dd27ecf0da005041cf7b2cc3bbfc374e4fd2e4882c114c6e5fe48789d6ce9b"
    sha256 cellar: :any_skip_relocation, monterey:       "d53bf5ec5bb0ba3c79d44a0f39167b26fbc9d6c215bb6997119622ef46f73e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a048e878df63d8521c7ea7527b3fc0bc4184bbae5a427cde4d87186945b7bf50"
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