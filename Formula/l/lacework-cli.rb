class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.43.0",
      revision: "e7f332c7cfda379def713be7a85c9610f69e87dc"
  license "Apache-2.0"
  head "https:github.comlaceworkgo-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0ca6bc52fe002fd6a4ed37e463d0a16e35bc7deae76de89f1127f412d72f645"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93a78e118777246a54540d1f0dcdde7a8608801ec7b28738c9c5a9c4508ebc4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ed6669ea0449f2367abe5e0a9565458fda73729ee2a98866383ee91092c089"
    sha256 cellar: :any_skip_relocation, sonoma:         "caf8d656693e787c6bcbfce97fdf94e20283f48cc209f180e2137e2de50755eb"
    sha256 cellar: :any_skip_relocation, ventura:        "8c531a1fdbbb694e095fff034cde11d632a15fb2136d408d62d2662750a95f95"
    sha256 cellar: :any_skip_relocation, monterey:       "cf18ed8413bfbd6abccefcda374dc5e983eefa3cc165802d48fb99b2e3fbbf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5995df9c4d20cc7e05566079202fc53f3203f815176be1bb6f0ab991bf5d858"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlaceworkgo-sdkclicmd.Version=#{version}
      -X github.comlaceworkgo-sdkclicmd.GitSHA=#{Utils.git_head}
      -X github.comlaceworkgo-sdkclicmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin"lacework", ldflags: ldflags), ".cli"

    generate_completions_from_executable(bin"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lacework version")

    output = shell_output("#{bin}lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end