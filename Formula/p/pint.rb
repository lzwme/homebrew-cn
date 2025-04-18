class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.73.0.tar.gz"
  sha256 "c4ab9040ddc463f04781619e550786a910f9ba806789152e1c08ae11c66c2a9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7cf4e72a15b363c4bac9bd30ecbcec119ea8938267c1832c86a55d8a55ac2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0334796f8295de540ee1cdb41db752c74584418362c70adf7b9fa5ea49fbcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f1bccf9df52d902140d0e139b2443f45e929278155f8d4253136893716d5cac"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bb85a834eb3236c094f893984d9d4a51956b7f7a0d71591c6b9bd99f6514ebd"
    sha256 cellar: :any_skip_relocation, ventura:       "bfea0c67bf502db79803cda4f8f6762d8c56d463712dc08e0a0493c6be3708f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c138e1f6dc522f552ca19607af7e49874c7776e1b2273d87fbe41966080d583"
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