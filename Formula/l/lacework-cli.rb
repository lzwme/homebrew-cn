class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.39.0",
      revision: "4e14a31f00ee3280ffae1e0f3b0f0d0b82011e50"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75ccf359cc566f7bd84e8d59380887805c69eabfe1ccbe079ab6e925ae821998"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0611c93e36394ecd7f62427775e00c2bfe1bf10ab369ad13f479f9441ed588d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed20b170054ea6f5bd9f39a5d57bce7d3d4d8e73d8ef26a3f80a003a0da6522a"
    sha256 cellar: :any_skip_relocation, sonoma:         "20a15ef396b8a0cdf5c864b9b6766b6a14f95e2275fc6c79cb56aa3f4babac11"
    sha256 cellar: :any_skip_relocation, ventura:        "d05879e441e6fd1fcc61afcc6bed97b5a377a1e81f2801a5c146d25f8228e42d"
    sha256 cellar: :any_skip_relocation, monterey:       "20f151f553059a3cfa603b07e0b88670c5052bc9802ad3115cdfd07ce5c67c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5082d453cfe32af674c507f4d96f301340afecf369385754bd1900dceb4df45e"
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