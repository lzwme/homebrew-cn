class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.63.0.tar.gz"
  sha256 "b7df77a19e2871eacf91ce8f210b33879f6bb68ccd869f6fb430a44641de7a0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4273321504aaabdd159ada3ab3a15e442f5c322b2eb0b254917edc7dd3dde8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f1db5f7b9952a625e89e24e381895b86a2acd282323f6f3fd8399d9f5f47344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365c6c30161766cfe590c62d1145f58415ea00034b3d182693a47cd255505c0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ab464c3f4ae111955e0e113f7babc987c8975848437b3a45c2c70657e77bb1f"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb0c1090f6224faa69edabeeea062711e40ff1f36679a337213d7d14a6dc8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "653c8b2e2b82d36f8da0ce708e0632180e7e73a450f0bcc71ccaa5898c7fa03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d57050ef8ff5277b9872bb0009b954916f1c803189c27fe74c64a0ffba64f2d"
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