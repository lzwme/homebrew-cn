class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https:github.comossfscorecard"
  url "https:github.comossfscorecard.git",
      tag:      "v5.1.0",
      revision: "b0143fc57d8d38748990027266de715052806f4b"
  license "Apache-2.0"
  head "https:github.comossfscorecard.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7c03f1004fc26c16a67afebb2ecca61806733ebaee6505cad42dfc2ac756e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7c03f1004fc26c16a67afebb2ecca61806733ebaee6505cad42dfc2ac756e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f7c03f1004fc26c16a67afebb2ecca61806733ebaee6505cad42dfc2ac756e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb0456b9d61894ede39f484ced49ff46f77897844cb72372891982539811742"
    sha256 cellar: :any_skip_relocation, ventura:       "ebb0456b9d61894ede39f484ced49ff46f77897844cb72372891982539811742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747d5f1a5d383717e487cde6e80d55c70590954a5a613b4a80a16c9c9220569b"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.iorelease-utilsversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "make", "generate-docs"
    doc.install "docschecks.md"

    generate_completions_from_executable(bin"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}scorecard --repo=github.comkuberneteskubernetes --checks=Maintained 2>&1", 1)
    expected_output = "Error: scorecard.Run: repo unreachable: GET https:api.github.comreposkuberneteskubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}scorecard version 2>&1")
  end
end