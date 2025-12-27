class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.4.tar.gz"
  sha256 "d4e3b9ffcaebdb95c4a4eb88259294c4bda2225696ec86853caa21442039765f"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4459bf3fd302052a6ee507ccf821be5e9b9eb5e40503d60a502f40a83d915b40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4459bf3fd302052a6ee507ccf821be5e9b9eb5e40503d60a502f40a83d915b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4459bf3fd302052a6ee507ccf821be5e9b9eb5e40503d60a502f40a83d915b40"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b4c00951b9d0f39d7f10986cf8822b90ee51f5f795e37a41ae19a42cd5704cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283f30a6029c8e9e04c87042dd7070071991ce95a3f74f62b805183cf10eb9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42a792090bd14d033d475307272576571cdb1a7a1f1cd8f9b51414599abe782"
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