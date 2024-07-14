class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https:github.comstacklokfrizbee"
  url "https:github.comstacklokfrizbeearchiverefstagsv0.0.20.tar.gz"
  sha256 "305cb3e65cbd1d3557c312720e97657b1b6996621e94d1d15856ab6271ec3d1f"
  license "Apache-2.0"
  head "https:github.comstacklokfrizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58a9de781fe690dc69df0f75c5639f1606e394cc3cd39af94ffd706861fcf8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d128c995bf622e21585a2d6d4903ea915e65cbfae3ad8b583d9c8afcd583c401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48501d0f86d8c81a59619b2ea2b6da6ec39eb38aea51ab873d2684f5d8f9dc5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "35248b2c3bad2acb1617784bed7186c7e11131e18624fe93ae663f758a0aeb60"
    sha256 cellar: :any_skip_relocation, ventura:        "0323562b1c089e27d96ae6ade0763f4115aca8d95c0c1b154602d4afdc637ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "e4997d864210452e35b0da6d890c4ee195d44c01f14feda62f232ce3cabf025e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9c63c3cc6e2f94fde15385a5a61513215248b2c77303e38dc46d5e827384db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokfrizbeeinternalcli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"frizbee version 2>&1")

    output = shell_output(bin"frizbee actions $(brew --repository).githubworkflowstests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end