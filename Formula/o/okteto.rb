class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.24.2.tar.gz"
  sha256 "bed08174eb07b96cd18c6a8b6428ce959d16ef41f04a705cd809c9d5bb767f5f"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8471565c305638b23811cb66754b9af8f9372e5f49db8d11bb3f058c56e3fafe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6753cc1a913d01cdf444101ffc794039b22899bb703250a5cdeb3c5d569028d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b92accfa0ef65fbabb1f08fd00f334b457ef9033fdcf01e326beadc6ead8aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2027be9b865084bef26852cf2e73564d06bf28f1e6c9ba4d0d44fbc4734d8727"
    sha256 cellar: :any_skip_relocation, ventura:        "83658392c038684949b4bf37c87f96270b54f07bafe8a2f9f02b110cd9a33207"
    sha256 cellar: :any_skip_relocation, monterey:       "6cfe7ffdf6e3e2b9d40a3a710e2b2baa1ebb27aba306f57228837b193fd8e081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e437885563d47f8c847f753d8fcaf3ce9f4c683b99a8c5b906ac6f09f5ce7bec"
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