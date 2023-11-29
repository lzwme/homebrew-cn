class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "c18a7665e836116e3858638e567c76f126273692216fff004886230b7adad6b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f63981a00f17a3f528e3fe1df0322c5bb06c82ffd2926a2d873a94a336c32fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "125ec4584d23234c143a9f4793f6374a7096b463d0fd2c50feeed05c39b70882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b61d21321db139eb9036448656b00af71b3a26f60908e8bd5426aca9f5f7c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "25b7c155cab9698c7107023a963f4fefbd1bd699478378ad4082ec178c6adc34"
    sha256 cellar: :any_skip_relocation, ventura:        "222a773a084ffa1e33def7018ca4366bd1cba368898c0d7e20234ca11dc0503e"
    sha256 cellar: :any_skip_relocation, monterey:       "eede41795beb39fc5aa1d0285b679c6b993d30f40bd18af5f1dc422e26c01a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e219304cd9bc8a2342c46b86d73dfe603e393a9829b9348e1632caaabb65bcbc"
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