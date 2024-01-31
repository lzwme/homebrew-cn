class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.25.1.tar.gz"
  sha256 "c1f6749cd506321d463c17b87f62de0f4d9548b9259aff7c7e57186296590310"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0e05ec878e1355bc13778cefb6c42a3270f8a1b3133097857cf53c508ee4c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8a137b91712b78377cdd03c73472879bbe6164efe36e8806689d7e411de2af5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7291bba6fd360fe9b27e68de598e4cb9f4cde80c5bbf4d83d6102ff95385b9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c14b89c6e5f2b0ae8e8c55fead35766e68e7e21aa7c6173385666f7cbb255201"
    sha256 cellar: :any_skip_relocation, ventura:        "8ca3a108c1552b45cd233a60535ff6056399f6dd60800a10e46fb7d186a7ef67"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b1ae80c62d826b3aae027da1328156f047d214e48e535a88b3156270e87f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4550d2dc079e46d2226cfc999a40a2cd23c73d25241fcdf983dc053a57f9fe6e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

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