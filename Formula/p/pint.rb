class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.65.1.tar.gz"
  sha256 "e893e2601044f223090f62e86af0cebb94a365ae178f6b2162b0ccdc42a5d48a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb78b4a58af4330542f3578e0dc2566640de4773f63d393f506fb0cfcef056db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb78b4a58af4330542f3578e0dc2566640de4773f63d393f506fb0cfcef056db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb78b4a58af4330542f3578e0dc2566640de4773f63d393f506fb0cfcef056db"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a377ab40d6897bbb62c7a5591dfd74a478019753aeb988a0ff301cc7f06815e"
    sha256 cellar: :any_skip_relocation, ventura:        "8a377ab40d6897bbb62c7a5591dfd74a478019753aeb988a0ff301cc7f06815e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a377ab40d6897bbb62c7a5591dfd74a478019753aeb988a0ff301cc7f06815e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22969557d702cff59f9fb94519e239e5b592ba23612399ff5490adf2f0d9a62a"
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