class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.3.tar.gz"
  sha256 "923b8d1490af15f08e475df4254d302c132ba8794fa8d9f468f6ab188eeb6dfe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a830d6cc18bb29d57a323b1548e3c988d7ee26e28739d479d94268445f1fd50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a830d6cc18bb29d57a323b1548e3c988d7ee26e28739d479d94268445f1fd50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a830d6cc18bb29d57a323b1548e3c988d7ee26e28739d479d94268445f1fd50"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffadef9f6b4f371dc119001f1512ab84c9571598b8a9b36bb61348faea1ec95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e974c78029590c20183ebc3236258a6097d88b4c2162c5b87f9d8c2e59778afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb0537d62d6ee860187f544b4908df6b1a8f2473760d11026024b75c9d28ae5"
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