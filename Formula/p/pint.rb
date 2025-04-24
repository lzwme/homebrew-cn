class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.73.2.tar.gz"
  sha256 "8ac02b3f122fb8840633120158386226adf0b6426f43242958ecd998a6061197"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335106aae85eae3991c7850e8f7e80344517a2b8a13317b96919e22304b691d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1f5791ff64ff7b9b365adf4c5f2ebd37d2da1aeea9765042281cd04d08bf99a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81dbf2f190153994a3513ce91d58f6e9d1a6cc7b750821365e0caf5ff2027966"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c23fcd4dead8b81bcce1360f5e4a8538edb67bdb3fe323063052833ad7abd8"
    sha256 cellar: :any_skip_relocation, ventura:       "74e18154f594e824b1c185d81ffbffedf21bb2b5ce6620889b8536d2f71ef757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b76a5d646f15a42db6d2e7b96e68b2e7304aff720c205c15b9b5f9a6ad3906b"
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