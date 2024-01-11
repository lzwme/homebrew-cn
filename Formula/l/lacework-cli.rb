class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v1.44.0",
      revision: "2bd0bdc51d3c3ec61c94c73826593206294aa758"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38379a990266bb34d539e0d25e7ff5f71e298f975625164a9e8fa07e50fadcf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c3f7014dfec3d21b8b2b472f514f7e4a7efc14920fe1349ab869d7106904cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f45714f08bdb8a769859b6c423e6249d85ddf4b24f89ccf5fba52edb029fffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d650b167b0efc8b7f73a3c90ca2335bd2af198abdcb128dc0a235fb27068709a"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcfee61939d2d6d620628785843ef7be2e61badedca9a7ceff14ce94c634146"
    sha256 cellar: :any_skip_relocation, monterey:       "9438b40264e96f5b1798c25292939a20178f7f9ba3b128aa16c1e5827b16c75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56dee5cd17d826c48ef0533ebefd10d4b32fdecd6fba2daab0ef97842526f8a"
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