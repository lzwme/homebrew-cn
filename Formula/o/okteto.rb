class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.27.2.tar.gz"
  sha256 "9024e7d3a4b0138d9979092266a840026eaabbe8ed282546094f6d590890ac35"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d771fe729ad56da16dd4fd13c53ec79427340afbb927537faa926ca422088118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06841db10283d5acccf19f37efed837aca88b7b47463a796fe081c57fa239fb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b8463b5dc1fc6b097d6722316c404263aabe7f8b19904aab8c57ebd254efd49"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef59cf03bad62be648fe64ba792e9f539daa6eb066fc44c936afcfa682eb18ec"
    sha256 cellar: :any_skip_relocation, ventura:        "725c93bfb63cbe5c5bdab7fcd51c130c1c098ac6c4106300a580461db60558bd"
    sha256 cellar: :any_skip_relocation, monterey:       "a72c895654c488567cf6d54dd742dd9b609374b9c05bf2d4ae868bc090a02f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c760308565289327b1c4153d76d6ec42c9228f9b27c560971c85b9f06b4dd5"
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