class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.5.tar.gz"
  sha256 "a6723a3a5cdb1fe6633ee1adbbfce36aa769f60c3ed018d926510769d05b7c73"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9829fa2d8598b48419a5b87df41502b987275ce1b768c6e0877d273dca331602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9829fa2d8598b48419a5b87df41502b987275ce1b768c6e0877d273dca331602"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9829fa2d8598b48419a5b87df41502b987275ce1b768c6e0877d273dca331602"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9dcc30b36935f324267bdde8b5938be788b6b3eb734023991a736745e0256d3"
    sha256 cellar: :any_skip_relocation, ventura:       "c9dcc30b36935f324267bdde8b5938be788b6b3eb734023991a736745e0256d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce169952905a4f66416fd48639fa92e3715171832010dde1abd19853f5431151"
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