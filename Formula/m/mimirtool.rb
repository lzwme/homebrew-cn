class Mimirtool < Formula
  desc "CLI for interacting with Grafana Mimir"
  homepage "https:grafana.comdocsmimirlatestoperators-guidetoolsmimirtool"
  url "https:github.comgrafanamimir.git",
        tag:      "mimir-2.14.1",
        revision: "c3a51a500b3e425019c34fbf2afe2714c60b4df8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b197b5f07bd34e4c837bd9d43c99c8c1769ef19a9089aa9271db90bc7020e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "558738e7f8d2ba4664903905d1855c5d4b34891f209091fb88284504bcdbf84e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c79537e74a189dfc956b46cbd4a12e3f10708c437adc6861004bcc1de4cca035"
    sha256 cellar: :any_skip_relocation, sonoma:        "80d06f75cc2a1426e6a41a251b953de39ad95bb9d55d9e135a710dde86db6b20"
    sha256 cellar: :any_skip_relocation, ventura:       "4c74761e0308f5d6fc9e4834852450a6a99662ef4f7ab86af8cd4b7277870736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46c709849da800b239b8445132284a33f62547e753f16add3b7c69122aec4b0"
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
    test_rule = <<~EOF
      namespace: my_namespace
      groups:
        - name: example
          interval: 5m
          rules:
            - record: job_http_inprogress_requests_sum
              expr: sum by (job) (http_inprogress_requests)
    EOF

    (testpath"rule.yaml").write(test_rule)

    output = shell_output("#{bin}mimirtool rules check #{testpath  "rule.yaml"} 2>&1", 1)
    expected = "recording rule name does not match level:metric:operation format, must contain at least one colon"
    assert_match expected, output
  end
end