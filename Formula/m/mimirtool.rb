class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https:grafana.comdocsmimirlatestoperators-guidetoolsmimirtool"
  url "https:github.comgrafanamimir.git",
        tag:      "mimir-2.15.1",
        revision: "0c1e06f13b90434e0e4da6118dcc2191ea23e8d7"
  license "AGPL-3.0-only"
  head "https:github.comgrafanamimir.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    regex(^mimir[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bee111002e87264d6013a6fcbfef9d7dbf3ad8d7155614615493c834d3ae2e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c5aa6039b5a98fbca79a27eee9468e7555be5a04212cd2e140ff839de87bce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba40ca4b91244547783bb8c0bc1cc1e2f2c0793e71b82035d2f4195052a0ee9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c0a0c6cdb83d4216adeb96605834bcc3d32c80a8f2c549dbcc84cb8a40ef9d"
    sha256 cellar: :any_skip_relocation, ventura:       "df58ce8ffc682dfc50b66c64fa9e68d92362f809d5a461646be89ef177157feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d918084085fa4a6c10fc20c50b59d3f1164309a08dab6fed6d590983e818cc8e"
  end

  depends_on "go" => :build

  def install
    system "make", "BUILD_IN_CONTAINER=false", "GENERATE_FILES=false", "cmdmimirtoolmimirtool"
    bin.install "cmdmimirtoolmimirtool"
  end

  test do
    # Check that the version number was correctly embedded in the binary
    assert_match version.to_s, shell_output("#{bin}mimirtool version")

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

    (testpath"rule.yaml").write(test_rule)

    output = shell_output("#{bin}mimirtool rules check #{testpath  "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end