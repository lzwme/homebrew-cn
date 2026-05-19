class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://ghfast.top/https://github.com/cloudflare/pint/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "3606361c8bf8ba8a5e10cab102bdb9c72b096f8b97b1431bf2010dbb8f3234e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cbcb384e37ed26c4225d44ac802631d7b97d4daba55988efccf0a1ffe6d1aec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69de5f4c984d4e06f2ccebc533c7cfd7d16fe08c3c2fdfe157b83238479e7bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb21d989e482c777763a488128c233aab97052f800c4a1728518a1582726a888"
    sha256 cellar: :any_skip_relocation, sonoma:        "051b014c02026c7fc7834d1b6b971a946ea68ff1206fb76fee5e83f23cab16ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f1708c2b89a1d839db4139f8dd9ea04eb7645d9a35031fbdaa61f904531dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af18da2f7f19682222d5247b564182aaae9fe0b2a8b2398311555f215823260"
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