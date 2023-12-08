class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.41.1",
      revision: "30819f41d92025ea005caa878a153544c4028b88"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e73b964be88cf0357472bb07e5cf92094ea20f8a58f88417fba9a988a908df05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd776866a93b94352239029e632dbe6574f5a17422c917519c3f0bd3d50e4ee6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6785383daff7b44ba29fbafffb88bc492f3080e5549e7f96d05622a779664a9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2888984ea92cac449ab60f731a078c5b273cd277a714f9b90287bfa0f7a9efa"
    sha256 cellar: :any_skip_relocation, ventura:        "dd494b9ab4dbd8bffff0ed3e60a462dcc31b6054165ec01b7d9f08e43f61e72b"
    sha256 cellar: :any_skip_relocation, monterey:       "aaedd858b2ae78533e58ec5876b59d1ab947ff918ac12b8364377ba881f9e9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4b37255f34a3a705ad49e6eaf13b13f1072814301a3fbab20ca6e5e5780a24"
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