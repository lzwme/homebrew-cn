class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.56",
      revision: "e97b56a2298da35f2cd556780118e0775f205f29"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3945c5dfa718ea9cc0d12afa16beb609a5b74e584ff647300efbea593e9e40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3945c5dfa718ea9cc0d12afa16beb609a5b74e584ff647300efbea593e9e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a3945c5dfa718ea9cc0d12afa16beb609a5b74e584ff647300efbea593e9e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "224f416e40d4a8e084eb237e9ed07fe3991bd0fcb8b442bc2b264c00368cd34e"
    sha256 cellar: :any_skip_relocation, ventura:       "224f416e40d4a8e084eb237e9ed07fe3991bd0fcb8b442bc2b264c00368cd34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c788cb0c7f7a2608ca98556497bfe333751a159467ad429b46616a58d5d1fc"
  end

  depends_on "go" => :build

  # https:github.commesherymesherypull14341
  patch do
    url "https:github.commesherymesherycommitfee7380005018b60912e25b404ea77314f489c5e.patch?full_index=1"
    sha256 "2ebba06d4f1079c6216eeea1bbc0f4befa78803fc7d471184e02813196559c3e"
  end

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