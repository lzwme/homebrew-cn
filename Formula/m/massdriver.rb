class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.4.tar.gz"
  sha256 "efc296df1bb46bc59b7924001741945c2b86ca952fd842cefeb216ac1302a2ad"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9b2c52996bf15d4079aa5ed845ff59b5379558a018bed633a74601457437c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9b2c52996bf15d4079aa5ed845ff59b5379558a018bed633a74601457437c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f9b2c52996bf15d4079aa5ed845ff59b5379558a018bed633a74601457437c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce80ea4d1be885bf87e59be2d67dc0ed7926619e69d493185836b2ac64b5aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1967345316cdc7d23bc092922f629101add834a71540e9e0917fa68a9c16070b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b3096f577df37658da50912ef0d54fec08c992cfaaacfd77d2447cb3f857b5"
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