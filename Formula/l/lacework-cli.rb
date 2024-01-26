class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.44.3",
      revision: "09aa78bf52368ad4971f18b67f1176cc24b35a84"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5edc51ca3f4f6416cf9a9fcbd5d6ab1fd2836c31b24913dc745d8d066ca64290"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2ad430da4db72aa1c933629a03154d4d51005d7f62d66496d97b1a5946540c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b8d7a92a6b1e3564367036809d59aca8fc857381fe6efcb719cac0a7933c21"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c6be9640cf9d4378c817fdef2d8e8b13031fb9e2bf7ba4117396e12aeac2175"
    sha256 cellar: :any_skip_relocation, ventura:        "a9e1b9ba5a4a5b372eb88e0fd1d0d90fd4eea121ca7adee51cfbccc92e70a7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf0f7625fc991c2f445f7614c9638034aeb06f894bce70c540f69c3d326d3523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c171209e6fb8a3da5d5e13f4a35aeb12e00a881d635265a02d5da451895bb4f9"
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