class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.67.3.tar.gz"
  sha256 "e6dd4702e06fced6513e360f85829c05ee263ecd4976bd99570f20ac4f549fb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb50b54b245774e9757277059899b22729565cb5d0bc43f2ad8a11bf63b6e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb50b54b245774e9757277059899b22729565cb5d0bc43f2ad8a11bf63b6e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bb50b54b245774e9757277059899b22729565cb5d0bc43f2ad8a11bf63b6e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb9a5fc7e38dc1cba80868a5f15d9cb86148870404ded2bb719d16fb14ec4fe2"
    sha256 cellar: :any_skip_relocation, ventura:       "fb9a5fc7e38dc1cba80868a5f15d9cb86148870404ded2bb719d16fb14ec4fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56452a1c0d5bb0c79c56e6c8161945e2c6be5fb046751c45ea6faa8d25b28f37"
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