class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.44.2",
      revision: "16ec8f40aa6e88290b7b7614fe0c47f81a2cfef5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c54fd401250bc64f35510f936ddf024d92d4a7ba470703313ae49491f3f41ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d693802183aeb1e998b18bd7ba4e1ce2980827a5fca3a1eec5f8078b8dcc3b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a241f485580c09e87ad4a47c87dadf320eec324603b27a232a554515fc31577"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee64fe084dfbda622f1e60ffa3a8c27c15d6a5f8ff3eb994f56fd94e5a176026"
    sha256 cellar: :any_skip_relocation, ventura:        "80939f83517d07c447d23cf797f72622b065f275f61f84c91ac1d3a101d37cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "110843e61a0c981e98359f5e8243692f64e8f47a3016f346a7024dc9eeceb2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af737f31068a9df24dce74bd4043ec6dc3ffc8fa00cdb56d6aec2bf205bde087"
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