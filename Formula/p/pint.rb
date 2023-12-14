class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghproxy.com/https://github.com/cloudflare/pint/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "3c73522c4dbd4e71a390b111523ea8117e6fa432fc4aa0f07c55005781125481"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36e2aa6da0e01502c2732530b6045264b8c38b61965aeea26310a1887712e190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef897b04abd361a752f0a5dd3d5c65703c07c339fa4ca77409c63c6bedf50e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4864dafe86af3b618e98df75eb72657c36dc69177524caa7ed33c60994ed77cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "060d59a6d4483ba32cc9909b42a7d017f3dab401845a43bdc855ee6ce284ca1a"
    sha256 cellar: :any_skip_relocation, ventura:        "09d3ab4aa6e862d90e8770e09d4536110496d5c69ea87f81598176d8517fdd80"
    sha256 cellar: :any_skip_relocation, monterey:       "ba2956244a198bc3cdd85c618705f6d689c32cc56b37f4fba3273e5f0cfbf3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7740d72966bffa7098948d2eb3bc27fdf0aa8ae6577ed5008ef81a0cdf1f17fb"
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