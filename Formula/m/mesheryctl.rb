class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.0",
      revision: "729aaf6cbbf87b04a9dbffa79d1e0f729cd08406"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7b494e143344f028844a281c507ff34646b79b821f0e69a67d281e6b42e8dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7b494e143344f028844a281c507ff34646b79b821f0e69a67d281e6b42e8dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b494e143344f028844a281c507ff34646b79b821f0e69a67d281e6b42e8dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0df614c814ab2d50efeba797a85b2e1fee25abecd6c12a149ecd5895cde4dc16"
    sha256 cellar: :any_skip_relocation, ventura:        "0df614c814ab2d50efeba797a85b2e1fee25abecd6c12a149ecd5895cde4dc16"
    sha256 cellar: :any_skip_relocation, monterey:       "0df614c814ab2d50efeba797a85b2e1fee25abecd6c12a149ecd5895cde4dc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b958d63a4df0f4b733cf648d4a19b3f4a8458758bc1fcdca6939ec77a32888fc"
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