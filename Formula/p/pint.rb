class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.59.0.tar.gz"
  sha256 "0c7c220fe59c2e1398aef741ec29eaf8b42cd3ad92f60f4016a79db0a1ae3581"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "983545fa47ef8c4cf24bf8f4fe9c395a81e7a425f9ad13608ab912e33d4e2ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19009ef090bc33435669a9e5d9b8097c4599411edf1e5449c79a5143dbea1818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a60b13a6a458e7c45ef25ec199ea0a113827335095e1f24069d1c600c1af175"
    sha256 cellar: :any_skip_relocation, sonoma:         "89fd3fa98bcfa8c1e4bd4b65edb7c49e4a9bc7ab2f952b62de95c868fe1763d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1f884b515cddb3fd5a9799e4c5c433a63e33ea5a3a9c23c37c0ffd0522371b53"
    sha256 cellar: :any_skip_relocation, monterey:       "32fc6eaf5ce7b8926fde88c8a8610a3d79b35e29d558b475eb70d160bc4c6a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de733ae9a6c3f308644cfb4fc36c0e2292b42738a37e9d46ee3cb8594b62e65b"
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