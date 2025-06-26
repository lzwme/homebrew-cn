class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https:meshery.io"
  url "https:github.commesherymeshery.git",
      tag:      "v0.8.110",
      revision: "2a92033b37c1f27040dd791684eb3a1aadf4d731"
  license "Apache-2.0"
  head "https:github.commesherymeshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba689fa251ccb6ff18a2a6124ed86fe2fa518358585761c24c7bae4567b8f564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba689fa251ccb6ff18a2a6124ed86fe2fa518358585761c24c7bae4567b8f564"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba689fa251ccb6ff18a2a6124ed86fe2fa518358585761c24c7bae4567b8f564"
    sha256 cellar: :any_skip_relocation, sonoma:        "dad31abc84d74e936e8524713afb006098f6301e1f303a5ce42e37cb8b475890"
    sha256 cellar: :any_skip_relocation, ventura:       "dad31abc84d74e936e8524713afb006098f6301e1f303a5ce42e37cb8b475890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4794e6a9e94ef2034cace991bbe7d8a3c254bd495e89ce24c6b9dc2e6883eec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d476a1bbaaff359b47ae081900ed7b8167c5de3db90ede75e5552bc57bd53045"
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