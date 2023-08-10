class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.28.0",
      revision: "c1efef4f9ba3f9512d0124b3a9271ab5b87744c2"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc51952e9f6066a553e23011f93c70b06e6f16c8199aa308129186d8b549e50f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "704a05e60845240950a18d616fac334dffd8ff300793249a9ebb192fde399a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2cfc2fe9f07f52816a5d4bee8b563d1edd2d6c4287da0a5e53c5dd97750f9cf"
    sha256 cellar: :any_skip_relocation, ventura:        "d8cfcdcca6f11f645407ef4099b0b3bf708f3b5a9066d2f4fd63d737e477ff54"
    sha256 cellar: :any_skip_relocation, monterey:       "0e97cd01cb4dadbbe994403f77e2f13b659bd983173197f9ae4a3dfed6400a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b572647caab1564d6746c48b40041f2ebb52c11193ddcb53b55dcd96929434c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e191413e8389390c447bbac7a5d82fc7771d32d1dbdfc976cb1c5c6d7759a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end