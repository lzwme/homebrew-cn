class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.2.3",
        revision: "d0eb7d8bef4ca71d13b3bc475fe1e1785c145eb7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/mimir.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(/^mimir[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32e23adbab34107580574ca1b14a9a29add8a0030b38845bc3d69b90720c9edb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "263c8c7194d5453187d5f33229b624c138744a4102fa8fd2bde01f2e273722bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c85cbe219a17ed354ba2d0b467d0ca6c4dee252bcc11cb65401f139b3674820b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffab0960e90759ec976bee8b8320eaca7e50bcb1be623a78841cdf262e75ecec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2864506f0b286e5985a6f85dabc3daffaa887538e7e44dbe70803ccecf808dd1"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmd/mimirtool/mimirtool"
    bin.install "cmd/mimirtool/mimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}/mimirtool version")

    # Check that the binary runs as expected by testing the 'rules check' command
    test_rule = <<~YAML
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    YAML

    (testpath/"rule.yaml").write(test_rule)

    output = shell_output("#{bin}/mimirtool rules check #{testpath / "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end