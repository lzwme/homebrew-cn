class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.35.0",
      revision: "15bd502f19e63e2793e34fe36ce37a90c574578e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eaa3bd483ce8da0c077bc0c03641cbeee1b67d0f4ad4b409b8fd84cc92e4ae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "723628dd54217738418ca229f37ea03b0e3a193debd3228fa4b75a6104679711"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35a6baf34b437e4e9be5b08ef69497670de1a7364ba14353b8ff5d7a870b16e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7647a8fce4c11645f8c34a3e356fe72345ebe02a20f56a406695516651fa560d"
    sha256 cellar: :any_skip_relocation, ventura:        "13804fc3477a736048c1d1d5f88016aee92a4a26425a3c202f3e87a3d2549a8d"
    sha256 cellar: :any_skip_relocation, monterey:       "d3ac281d41bd6bf018394b7db3af33f1fcec42c07202b9d6f66f06a59c733281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adcca004e581f63414d085aca99cb839973ea9167b2cf78800032e9ec2f88b9b"
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