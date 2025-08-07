class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.7.tar.gz"
  sha256 "f5fc6db5aa3abdc6e476356e7272bceca4afe5a546900a315208557fe1f3a8f0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31729a473008825266401fc3e68eae5b5e9df92635aa2920769ecec89476ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31729a473008825266401fc3e68eae5b5e9df92635aa2920769ecec89476ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a31729a473008825266401fc3e68eae5b5e9df92635aa2920769ecec89476ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be966785ccd8e03f9a4a96c9a38917227f388a174b3c7349c9e25b5790e21a6"
    sha256 cellar: :any_skip_relocation, ventura:       "5be966785ccd8e03f9a4a96c9a38917227f388a174b3c7349c9e25b5790e21a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011562e2aeaa6d751575fdf047ba7a58284d526e28a40d2db4ff1a843947c856"
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