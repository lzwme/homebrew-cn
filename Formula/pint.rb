class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "9a2a9b6482e3ea7ac5f9b36a0a6414b47aee4b4a924e2c7abf448b5b88b543d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63026e97a6efd9fbca6c9455f58e0325170d6a5b774d036afbf43f982ee679f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f490af5ddf4a2c508043e13b93958c2655d9774fa33f59e20e0595606dc26e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4993ad502d81df2dae17fc861c11bfe0bda7598f6698f9b51868143cd46ec5bf"
    sha256 cellar: :any_skip_relocation, ventura:        "16265e1ad4f90045ed983d373086845b561b7d1bc656c35fa60450e8f395cfca"
    sha256 cellar: :any_skip_relocation, monterey:       "e78b17abe1d37dfcd6205f79e22db124f5c0d2c874880b8868326a8d3cdb1889"
    sha256 cellar: :any_skip_relocation, big_sur:        "b907ae2b4804fc8e2387819f029668c7f4c99a9645ed72453f80a17dc0d4d700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e998a192da9196fefc7dc02b98732a9985f51b5ce28464fcbe45683d607d4237"
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
    assert_match "level=info msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=info msg=\"Problems found\" Warning=3", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end