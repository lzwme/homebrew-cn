class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.68.0.tar.gz"
  sha256 "f0414f867a378573d1f9260d55bfdc2a347490a17ffb921126cdb9d29b285739"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7df989d4afadb564292463bd44445b1128d57ff3ac1f2e5bba62e7de982220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7df989d4afadb564292463bd44445b1128d57ff3ac1f2e5bba62e7de982220"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b7df989d4afadb564292463bd44445b1128d57ff3ac1f2e5bba62e7de982220"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd660b8c6e5dbd117a94eeab3ef554beedab362abfcebf5f39759bb179060f49"
    sha256 cellar: :any_skip_relocation, ventura:       "fd660b8c6e5dbd117a94eeab3ef554beedab362abfcebf5f39759bb179060f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae3fe0f2996d62435505f460bc4908e280bd86f900f64063c8c70cd08dc85d5"
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