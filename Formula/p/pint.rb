class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.62.1.tar.gz"
  sha256 "49191c40fb4c96c9316ded909571553b0f773101a842519e0b85af313dceea31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4642a40a4aa76e0642955537dccfcd181dd99abf1efe704ffb35a8af468fef3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01343fa7041d300a4e59d3d8237f964530548d66696a436b5a9518841523a92c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "312f04ac22a80968acdf9759f9750c3b06c6b17896f6c86953eb903f06b539d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a10f8790baf86154fb7c9687e40552974de895168c03794a519d51c444653b41"
    sha256 cellar: :any_skip_relocation, ventura:        "8b20ce93c86ee8a4c7e5fc66e7b11807fb6a167f5dcbf1c77da0a846ec351db6"
    sha256 cellar: :any_skip_relocation, monterey:       "73908021dac5833a930abbc730f73fd0c4097f21b5c7f44540bd7a4a26168e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1992351122245bdc536598d99f5185429cac00b5d671e8c9f04e71131f60c2bd"
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