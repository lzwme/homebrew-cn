class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.29.3.tar.gz"
  sha256 "026aaa44b52b1518a4030624f26fb4279c51cddf06bfdb1fa333e82c4e1e38cd"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24618c272e6a912f32cd4c64ae0c837e8d74c958351e7f94057202cde4ce32fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6644ff1e721012d901bb242464601245bef549c23b2281d2339184ee5cf784ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5756ae039a524e79722b1d6c6db458863b0d5afd1a2709c2d137f9143477658"
    sha256 cellar: :any_skip_relocation, sonoma:         "0524ebd08a0ae80f99d3b2c62fd5f40400ba6655d946552274ac95ddcf3d0c9f"
    sha256 cellar: :any_skip_relocation, ventura:        "6a48fb29ca0cdb82b6c536684b708b3f7d989d3208938a13e0f6f21799d10aca"
    sha256 cellar: :any_skip_relocation, monterey:       "4938352a575343681379d9c61fb461936ec667e2bff590fddddd0eeb54563b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de66ebb677c2922a0761142b910103db5a8a53bc597aef47671d4f50a7560733"
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