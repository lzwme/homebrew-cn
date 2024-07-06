class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.61.2.tar.gz"
  sha256 "0e4e214ac5aeb5e9209b53ce7fe590a736d8f1ca9353842adb5ef2f7d6287878"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8e65a31dc9fc72276b4b120921880338eaaa090754634b0190131ee05910f32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52ae01fe3dd6decc35d99fe4067f01c41a91d959d485856078f5d203a7ee884e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c84f284ea8e2eb97e6dadd5ed6c0eee8968f81089e0ca76989d78ef797678c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbf8d95215c7943ef2e8ac458d4ed1ba93ab6d0e7b5e7a064a0fad181a88c0c1"
    sha256 cellar: :any_skip_relocation, ventura:        "bb97aa285c89c70dd2ae153566cb2a81dabf8c031300b68d27c700cabf74da26"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc434817deb42ee608fe28cc9fba35b421263265e916aa0a47e06d660adb1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5100b4a9dc5a4ff0a29501d679e6d5d054969089f420a4af4153f6d7c4ee299"
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