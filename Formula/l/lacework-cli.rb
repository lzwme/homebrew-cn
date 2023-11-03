class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.37.0",
      revision: "c83309bcd9a41783638a55d9a8c19a58b7217320"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2977dc189c93546920ab6202beb15ef69ecfc201144db5d1aac33f30c29e6f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c72330ada0281da0a10ad5ff8c1225bbffc3cd452acdd5e5dee3f242c242779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b8a837ddae9c6988efed687f97116447eaba8c44241079b4341fa73f875d8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "10f7da36356daffce16b3137a13668447997654c7a5a45158570af7ce578c0d8"
    sha256 cellar: :any_skip_relocation, ventura:        "26ce43005c05ce008f12e17156e9312555449c77013495a6f5c2eebcf2d4e0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "13b014ac8959b2ead7fd2d92f5100a2dfaa730c9745fdadfa6b3f2530f495df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e3a23be6e6625ab9aeb626f30957048b0d45aa04440b1ff58d57f4ff273634"
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