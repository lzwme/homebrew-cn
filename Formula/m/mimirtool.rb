class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir.git",
        tag:      "mimir-3.1.1",
        revision: "a3d6c90f25a97bf16545334ad20e08223ee89d92"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc15f0f760be4de379a7535d858b0e041631f879c776a8b68506942e0dd78cfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a1ff23d4fec508e9179b958a00e18f0d27eef9d511fb6956bc4fdfc32ebbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99434b9276aa0526ffd57d18de1b8c1950fa1cff1e0e592089586bdb36e8ac2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "49e0ab7fc0676aa0e4d1041fa90d5cd364ba9a420cbbb3243242b91bfadcdb7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00e951f6706e1db43d47d7ee047b5118a91312f352ee3960e80cb6eee1f9957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f8c96facd461a1f2991ad2ce4d2ec8fe8ffc7a9e1b5d086b5738626fa033fb"
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