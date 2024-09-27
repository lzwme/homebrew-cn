class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https:github.comekristenaws-nuke"
  url "https:github.comekristenaws-nuke.git",
      tag:      "v3.23.0",
      revision: "ffa18ec49c31b1cb28f2d3d7f26d00d6c4c63056"
  license "MIT"
  head "https:github.comekristenaws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2936dda5d221fb128891cc7fca2b4b4ded843ee205d5a3cea24825469f4cae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2936dda5d221fb128891cc7fca2b4b4ded843ee205d5a3cea24825469f4cae1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2936dda5d221fb128891cc7fca2b4b4ded843ee205d5a3cea24825469f4cae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ca293c92f7bdfdaa5c762d84d14cf84722e0a30d443f6bb0c03ca9662890dd"
    sha256 cellar: :any_skip_relocation, ventura:       "b9ca293c92f7bdfdaa5c762d84d14cf84722e0a30d443f6bb0c03ca9662890dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1206061e023290b088cfaa4fb74834b8c36cc83ddbcff00ab414ef6f52048663"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.comekristenaws-nukev#{version.major}pkgcommon"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

    pkgshare.install "pkgconfig"

    generate_completions_from_executable(bin"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}aws-nuke run --config #{pkgshare}configtestdataexample.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}aws-nuke resource-types")
  end
end