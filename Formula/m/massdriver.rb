class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.8.tar.gz"
  sha256 "a8bed988764bfa99ae4f5275fcdb670cd08b0aa5897da9f85b9a4ff2c1a5d3f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2e4fb66755b67005cd8a4ff76f480cd0869062b6e924e995ccd19c1b2e9d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f2e4fb66755b67005cd8a4ff76f480cd0869062b6e924e995ccd19c1b2e9d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f2e4fb66755b67005cd8a4ff76f480cd0869062b6e924e995ccd19c1b2e9d3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "539ac7830539974b4f57747eaeb4e23bfcf93a9a91d4502d3b92cfec9eb29f9a"
    sha256 cellar: :any_skip_relocation, ventura:       "539ac7830539974b4f57747eaeb4e23bfcf93a9a91d4502d3b92cfec9eb29f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37bea579babcd6a10d21eee669714cca8fe0b6f6723030983fa47508238896e8"
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