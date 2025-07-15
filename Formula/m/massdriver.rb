class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.4.tar.gz"
  sha256 "fee7bfd38dded3b735b220b1b24759e4df158806d905122465917783833676e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61173d81cf0ff9789dd370803142d162708284f48f1f906602bdbeba032635a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61173d81cf0ff9789dd370803142d162708284f48f1f906602bdbeba032635a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61173d81cf0ff9789dd370803142d162708284f48f1f906602bdbeba032635a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "484619fa72eae86471a4105a537a215dd8951784a22663d5ce60c86b2ae7ab86"
    sha256 cellar: :any_skip_relocation, ventura:       "484619fa72eae86471a4105a537a215dd8951784a22663d5ce60c86b2ae7ab86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f620b39d5142b74f85923386498b561177abfabf0cfc5ac6a837d4098e6130ab"
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