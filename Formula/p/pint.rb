class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.6.tar.gz"
  sha256 "d78e69c525ee21d41cca8f6629fd56f9d7f3a1ebdf919a6c729b4c89792a5b17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51c1ec7517ceebdbf7ae8397ead1e45c879ec558597ccdf7d61fd3ab2bb0f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c5023038962f4448e3d437dda82fdce292508cf57044198f38608feae946cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0520d70e52357ed0447ed3eb78e96bc12fe386e916650e85ff1cfb23708035ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "30314da5c38e7ae646c3efae33ba00d2afdf33a3b890d7568e42f993df387003"
    sha256 cellar: :any_skip_relocation, ventura:       "d6e59d2193f168b694d7ac82cb20204d143f808655561e83799faef937058430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b29cc1fb35545106375acdfade23d20ad55f6bee1ae23d5ad84f75d7e6b4487"
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