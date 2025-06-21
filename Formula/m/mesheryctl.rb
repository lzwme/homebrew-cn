class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.107",
      revision: "bbca057d598a71330b5dacd34795d42097d2d3f4"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2c31aa9dcbf97e8842acb70659dd3175baa6941322188daa1c893a50cb88fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2c31aa9dcbf97e8842acb70659dd3175baa6941322188daa1c893a50cb88fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a2c31aa9dcbf97e8842acb70659dd3175baa6941322188daa1c893a50cb88fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "861e17ec49fc951ae87093d4dc10067675bf2e5edae25700e6f9d72ceb7c7d86"
    sha256 cellar: :any_skip_relocation, ventura:       "861e17ec49fc951ae87093d4dc10067675bf2e5edae25700e6f9d72ceb7c7d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "383f6603a7e40f943e78e6f3350a5462ecdd4e36aa25b3c41d7b052cdbeef352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a008b0b1308587b4d72aeaefef34a6691cacdb2bd0112ef93e11ff87cc94bf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.commesherymesherymesheryctlinternalclirootconstants.version=v#{version}
      -X github.commesherymesherymesheryctlinternalclirootconstants.commitsha=#{Utils.git_short_head}
      -X github.commesherymesherymesheryctlinternalclirootconstants.releasechannel=stable
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