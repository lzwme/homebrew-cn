class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.82.2.tar.gz"
  sha256 "b190473d84c53a9c4edafe46afcea3b0d44f27f7e0d94d03e2353eabc547dcdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b29fcafcd11068faf106e63a639eb30fb48b8e7926394935530a015e5760a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7609e34e044c6610341d60bf09ae9bc66ce13a7eb95e45a006766a1f812e0b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6b8cdca6ed752438508aae4aa48da107e1c402ab16b7aa5996633b8516a5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff756a11f2ee0a1250ef2d00d8283f3bbca0081884a3fa808a671f00312ba42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "544dcfbdd58e0016ca39b6dea5c6da4bd22e269200eae5ff6c4cbb63dfe59e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cc3fbd19ccad6142799192c8255ab95d403d7d19b7c4a7c8433b5d0b7399ca"
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