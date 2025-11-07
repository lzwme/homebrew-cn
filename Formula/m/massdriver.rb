class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.0.tar.gz"
  sha256 "48ba79c8860466c84aa1af7b5fdbcaa1e153d89620446165fb595cd3e5997b92"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc6605ea334e0311b46438bc52c616ee3175c4c9c5547e10454121f276d38081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6605ea334e0311b46438bc52c616ee3175c4c9c5547e10454121f276d38081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6605ea334e0311b46438bc52c616ee3175c4c9c5547e10454121f276d38081"
    sha256 cellar: :any_skip_relocation, sonoma:        "185141a087ee699a03f06f90d3fc161cba6dc8b89ca17b2ebb60600e44caeadc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0cb23fd8ea8b7728df3784c9498a8c0201d5e6e93e71ac6b589f7a4c1c60c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf745047b0baedda2ab5fd959084826446e21ad3b1f893135ace6e61a03e4a00"
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