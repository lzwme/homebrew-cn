class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.66.0.tar.gz"
  sha256 "8471f17d6a719035327eb2876a073f4782e8a8428d94bceaf3f267f713bfc741"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cfc947e364f1c47367bf90daa034b0bfe7a4e2df66d9860dd4a19df1f0a75a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cfc947e364f1c47367bf90daa034b0bfe7a4e2df66d9860dd4a19df1f0a75a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32cfc947e364f1c47367bf90daa034b0bfe7a4e2df66d9860dd4a19df1f0a75a"
    sha256 cellar: :any_skip_relocation, sonoma:        "32035b82086350d9ed2d2d718a7096bde3344394c66d51865dcd376cd4db407b"
    sha256 cellar: :any_skip_relocation, ventura:       "32035b82086350d9ed2d2d718a7096bde3344394c66d51865dcd376cd4db407b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577062ee701c120c32d847977aaa5d88a84fce242db52feaf45a683438427fb2"
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
    (testpath"test.yaml").write <<~EOS
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

    cp pkgshare"examplessimple.hcl", testpath".pint.hcl"

    output = shell_output("#{bin}pint -n lint #{testpath}test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}pint version")
  end
end