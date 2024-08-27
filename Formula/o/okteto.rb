class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.30.2.tar.gz"
  sha256 "f5a49499e75016dedf5cedfa28a632d59fcf406c24458a6bdae738d8bdd755a3"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "466552c0581c2dd98e551fd2bb81f9630d2810a2db3dafb1fa551bfc388d6e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42531264c7a55c22a06524cdc3ecf02a75cc22e065f112a85291eeb8042d4dc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b60e9e8af75c032b7300f6bbbdbcf037ef6b08d06a40e8563b7444e1aecb56"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dfce0282118b7d34becdb9db0daf712a33d9c6c7f6c938fd8593e5e4e071c73"
    sha256 cellar: :any_skip_relocation, ventura:        "6fbcf399b52fb0a9cd68968c825cdc7d61110f746c60e76f5f008c899ba09172"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6d79cf70a6090b2477e505eebd6e475634dbb87a3d35a2988f8d074bab0822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d24c5e32a71e4fa358f5277c4f62b0f000675fc06c44098cdee87deeaf72953"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end