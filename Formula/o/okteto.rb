class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.29.2.tar.gz"
  sha256 "751a065e014a8cb1dc3b7401d9f124d2d8b2825e5b5d7590250d8d0744634a25"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b16ef077929f3a1d3741616677dc7bd259f8cd3b1c6a36fe631e2424b65b0ed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a9a10f6cec6d7320cf3e8c4ec44bd0f62cc46df1816f56f3d223bfeedc9474d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0726a39bcbef79f5485ebf87270ccdb0f69e49844223c812eb2899462e7e3b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d95660dee3e3e456dc6673eab6bab346ce52f8560952f8483d7ff1c0fb9e99"
    sha256 cellar: :any_skip_relocation, ventura:        "cb4b2baafa4c8fb9b097b2f4b8a33050d5a7c619679790859af93b29c6be51f9"
    sha256 cellar: :any_skip_relocation, monterey:       "b49e24fa1f6b413dd39762dcca53336af34128fadf379cf8996d23a83a961370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43348b5ac91669a7917d72aaafe491e126dfc8cf68e8b6a43a8f0ae87f87039"
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