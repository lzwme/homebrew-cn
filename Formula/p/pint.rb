class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.62.2.tar.gz"
  sha256 "de0ff98953e1c0298c026334a56c3186906aaaee8dd53edecad4c570cbac31a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08e86cc98faf3fbb66219c97027360f7ea5eea6fb636f3183c4b40d9a1ead311"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cfdff558f21af01bb7955243afd076047550e573dcaea5fb35a09140b4ad52d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3162485036b801da0b25c5f9b7af0c507477dbb024a02127487230f6431c2f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3d4ffac6eaca6cfa04ebba35d6eb57c073f84929d5f0a69c0891ee368d74515"
    sha256 cellar: :any_skip_relocation, ventura:        "55080dda125f85bc6e7762d74a772f5cfa6673e61b20c565f9913bfb620e2276"
    sha256 cellar: :any_skip_relocation, monterey:       "1b368792a1c877a4a0001fb1daac32c11367686583dc7583b03a740497bfce7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b2c2a8dbfa5a1f02eede2f036a360e50594b58661aa1cca428786eacb15258"
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