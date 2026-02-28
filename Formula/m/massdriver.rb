class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.14.0.tar.gz"
  sha256 "fa67761491daf1a4fb08014649d8d1f3bab2eb3ffed9052bf60fe1ca5248fe61"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3510dc3fe14b9b608f994125da622616c501b8bf6ccb9e1c73a40b27fc8afa11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3510dc3fe14b9b608f994125da622616c501b8bf6ccb9e1c73a40b27fc8afa11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3510dc3fe14b9b608f994125da622616c501b8bf6ccb9e1c73a40b27fc8afa11"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d285b59d1b78226bab9bec11a151813b48df5c91b301281a1fc1ea95885b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98615234cf892e2ab433974877e9f79c420eee566dff6340e4d43fbfe13a7165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35aeefee9fb290c47bb188fbfb3cf696765527f4e74ecd659d8c39fca4540bad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end