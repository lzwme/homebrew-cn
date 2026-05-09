class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "2e736571817173bf1e2af9ed2946f1d98d17866bb4e6983707ceac58deb23d12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efa15cae550d74f84d97f35f6288856ed1a58b610f58b8cd74aa6e5eb26c613a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df60fe4be67b0d12071cdcd397a1f25b89bd06aaab0005568ac9b2160e7b5a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa0cedae1e102f68d2f0b450203035ef7acaa2e7aca66feacda3cd26ff1dda1"
    sha256 cellar: :any_skip_relocation, sonoma:        "784860e24c9c1722bdf4054cf5a0d69c4c67dd4bd878aacccac0238486aba87f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63517bae2daa305d9d194c8564c5a772fba2295f2c828e45da03a8fc823d0b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e231759447947f9aa94200647c1069ff643b39f8fe6c19fab43acdb525dfe61"
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