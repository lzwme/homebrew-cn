class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.32.2",
      revision: "be854786d8b6263864f1678611b2794b7a64c92b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a798427ff62d7546e13bdc5822d3496bbc78fe4ddb250ab0991b83a0205457d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94291f9075045886e8103e73b5b7fd61fb18b782702c15713471c5ac4c115991"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9c95dda22cc5479cbe1ec183b66f5d7486fe5c82d02f42dc39034145e24eb1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76d6ad0f57fa7e491302fbca6a75ed4f93c4e76423606d1b8383fed03d88f56d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f90b737c60cb076524d949bded1df5814a487793d79e34f8eefd99e56331b689"
    sha256 cellar: :any_skip_relocation, ventura:        "6d0a1d483c1d4c725ae11dd0215144e470f2f882f84428e1164c3c890a7a287d"
    sha256 cellar: :any_skip_relocation, monterey:       "888a1e7627f1b6a393a5e8f1e82783b0aac4a44f38fe47f04136169b6b15744b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0576adb44ed5cb12714664efb84b42948634b09d998b3069a14049a407ac449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60343fa0c92734201470f8fed5868ade710f18bf074c54eaabfaf072db18bc1"
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