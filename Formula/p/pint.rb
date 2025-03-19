class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.7.tar.gz"
  sha256 "589fe428338de4604a434831895a4eb068c0c2cb8a09723a58b3c8915c5184b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a6e0b4949fce6a5f0a25f027acfca74c6b4a7fd1cada77ba69d55189970463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982812e2f28f0bfbb5349a27269ba27a5261b2d7baae60e2e76d58345103e0b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36a30496188073c15592ac70289d8ac36504620cf07883450c573b1c530d3416"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab06dac6a70f4da3f42b1a1107b7faf8fb44b1d00bd0c1d2530818574d405171"
    sha256 cellar: :any_skip_relocation, ventura:       "417878c4e9ca50141921a21f22ecd99d73872e485f7380ad0c18f5aaea6fd6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bf24b936cbc1f23613385c43ec67d49be746f68d6d09004f8b03fd39a06b82"
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