class Pint < Formula
  desc "Prometheus rule lintervalidator"
  homepage "https:cloudflare.github.iopint"
  url "https:github.comcloudflarepintarchiverefstagsv0.71.4.tar.gz"
  sha256 "105c97c8d6800ef854941a58aa707749d6cd3309a1221fc118acab9e72c2d3a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed52a92021a8a173a3823941c84d1ba801a240dcd88e77276faf7c03626cdbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "801983ae8d232213b7b983ef049d3088cc213de618c96c3c00a91584af0ea1c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4277ed5951d7af6fefc894ea0adae6500a88d65c734b9871820d66f3d9286a5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71f39c50a0b82472af8523484727099857a014887698cfae9cb85e32272db8d"
    sha256 cellar: :any_skip_relocation, ventura:       "dc21c21039ab36a93aa56b956c9101e0a788a82f6eeb890575b2e2ca06a27092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b060033968d03a5d0658bf97c82380490153e366070eeeb890db6bfce890ec44"
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