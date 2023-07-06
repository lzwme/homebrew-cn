class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.26.0",
      revision: "6a1927257864dbbf4149270410d6fd6a228bbdeb"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6effe7de2ffee597504869684ccb4af8e5ba8ab081f400e3c4be9874013c2dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a80e1b22f94332072bc88ad59c6ce3993b6e8b71e9bb1aa977e281a3cd7416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6195d4e57a65eb738a6bfbc811ccff998ba210ad5abbeaef23daf57fd70dc7d"
    sha256 cellar: :any_skip_relocation, ventura:        "535be03f8fdefcbdc9d36259376a626c4b74bc50ad9e39836e9986e4d5a64fda"
    sha256 cellar: :any_skip_relocation, monterey:       "7cacfec08ba377b0866523ee175ffa9cdcd9842fa4591b94ad6b3e52b564adba"
    sha256 cellar: :any_skip_relocation, big_sur:        "776ccc10fe386fcd0b364c96534f53ad437d88cd1c902089f30c939abcf4daec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c654883dea6389f9034c541968e718fecdb33603dced12143b7f78f2af9538b0"
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