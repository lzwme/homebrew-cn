class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-2.9.1",
        revision: "68740e402cf905970986165fd62998ec57cd73ad"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^mimir-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f386b9c1f0a839dd65377502de48e4b814bc16fb4342ca0f59dea97bb99f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42cdb3977818a00394f048d93bf7ab1bb3c4a8467f909a3eae68efebf22f9159"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b73b917c1ddbe8e9dcff9ef9c4c0640b228bf794a3c8dd410aedb5ae8da4073f"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0c4ae0a1828856ad9fb635d334afb9e80661899c7dc3598d78cc58399a66fe"
    sha256 cellar: :any_skip_relocation, monterey:       "f14ad08de373b87863faf08d92fde952e54cb504683fd7b302d54b640d7145be"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f68ca4771ace570b4cc508dd1eb26941e2d7620a783bcc1dfbfceeb8b3da10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8587331c43ce59d9558510eff3c931c4cb7b9d1d939d44b2c715685cd2e60de"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")

    # Check that the binary runs as expected by testing the 'rules check' command
    test_rule = <<~EOF
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    EOF

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end