class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.45.0",
      revision: "f5a55c0830f7127ce3ad53da3f71b4e45dcbbfc6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b130575d5465551ac4f400247115f03cb7986ecb538e11335713230d954467b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e830c2b37956428f9d46908aae101303e586cb459cefc5f9382bcf80fd3ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31c381db816771c2713dc2290b39d6b174e6e3d77e6f08801e11ec3b7b9d21b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e29fda92edb8967288a9458750dd0b63a5e6ba63159f2d8c7f6df38471e68acd"
    sha256 cellar: :any_skip_relocation, ventura:        "d1287e34c17663deae40952f94ba65f3bc269b04443ffed3920cf1133e28b348"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9be9e14a64239f2bd4751a76eaefce630ce4ac50917d5e379171f59bf361a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c930ec7e45b8254fbc0dd3fbb50279ad816883de81f7d057d5f093946758476"
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