class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.6.tar.gz"
  sha256 "3c3de384095e2a518b59a88b5cbacf4d824a6a8832df79985223df6b54ebf664"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014a383e6bf8ecd8fda0fe3027dedc3acf3a7e5d4fec4ba993ae2335b57fda25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "014a383e6bf8ecd8fda0fe3027dedc3acf3a7e5d4fec4ba993ae2335b57fda25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "014a383e6bf8ecd8fda0fe3027dedc3acf3a7e5d4fec4ba993ae2335b57fda25"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e1f5ce70c15c04f0f087a37aad8386429d3ed4e63767329e154c9df1a73d9cd"
    sha256 cellar: :any_skip_relocation, ventura:       "4e1f5ce70c15c04f0f087a37aad8386429d3ed4e63767329e154c9df1a73d9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48b997e8b923505d9f9b2a0d86323479e384f13e7ff574a72c82791882c6246"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end