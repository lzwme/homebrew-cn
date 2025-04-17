class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.72.1.tar.gz"
  sha256 "a4e2f4d93e7950530e110a994437e3060dffb19e538076d556507c48b43e4aa5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a2b5aaac66bfae8804878e77ee89aba589263179423b37b14220a3b0057909f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5dd284695d0de8a6f93792847854cb53a2488722a1c3ba659844945be581de5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6b42c8af24ac0ca0eab53cdd7be38b3886dd9b883504bb7ce0ae1123c91c133"
    sha256 cellar: :any_skip_relocation, sonoma:        "38f6ba34b0281e5418d04e444112c7754ab12489072e555b66a842c240c61252"
    sha256 cellar: :any_skip_relocation, ventura:       "0d4159125ab968ca92ec83aaf86d9d04272ee075f2bc1e45a8a2ac863613d5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de070aab3c1507753d87b27094b42d98c53f27c2bd61800c8a78b9962323a192"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpint"

    pkgshare.install "docsexamples"
  end

  test do
    (testpath"test.yaml").write <<~YAML
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

    cp pkgshare"examplessimple.hcl", testpath".pint.hcl"

    output = shell_output("#{bin}pint -n lint #{testpath}test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}pint version")
  end
end