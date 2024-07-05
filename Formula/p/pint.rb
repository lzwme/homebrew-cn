class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.61.1.tar.gz"
  sha256 "1f475c07b932daa8ef6315da5740e64f7180075e99707d8f4175214ec81c0b25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52590a71abfe0ebda1c0e1a1aa8a721a922c573f867513761310cb7a2d9dbf33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b1aa68e5e6c0090c46572e50a514721319ac406af93f860e9f7192e63eb034f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b3008263044de968176968133a6eb96c010a6436db50dd1477253f59b15fb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e105f70ad7d1ff1b8cac7a383f4566aca4c19d3d552d0a61bd0369deb890684"
    sha256 cellar: :any_skip_relocation, ventura:        "b889ff639721cf313f7e8c278f52af226a73cd6667a802af85605e48ffac2799"
    sha256 cellar: :any_skip_relocation, monterey:       "788cdb5a9ef10ef25750729706d32b30d7b79ff1529a87bf365010458ac5c936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775f35cb1be25fb7db5ba27846536385510c1069e0347c6194754b3b3ba0fe23"
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