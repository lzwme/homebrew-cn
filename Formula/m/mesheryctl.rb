class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.7.108",
      revision: "c3a454f4ad7b317a8936a68c3207343e7a28b3d3"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31bf2899efcab6937cd6a9b8a162dfc73a86f20f5b4843a4866dc9b122ef876b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31bf2899efcab6937cd6a9b8a162dfc73a86f20f5b4843a4866dc9b122ef876b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31bf2899efcab6937cd6a9b8a162dfc73a86f20f5b4843a4866dc9b122ef876b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5931fbd6e8e87ee9e64c6258d2b590261723f4f558b891abc7bf5af93446779a"
    sha256 cellar: :any_skip_relocation, ventura:       "5931fbd6e8e87ee9e64c6258d2b590261723f4f558b891abc7bf5af93446779a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ecfbe549d63fc53a2218f6f7aa643606157c1a6beb84c7223a41acec57d4864"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.comlayer5iomesherymesheryctlinternalclirootconstants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), ".mesheryctlcmdmesheryctl"

    generate_completions_from_executable(bin"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}mesheryctl system start 2>&1", 1)
  end
end