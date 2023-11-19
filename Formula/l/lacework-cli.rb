class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.40.1",
      revision: "9b388c7b7d21b74c774c84a2be1fa8cd2d6d70ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eed0be20513203ea242be58a9ffc0ff392b83e75365b773763207825c20e1898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe053fef977af4e7ef33f36f1d46da4bbc36495d17805124f7839c504997521e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15ffdd736db507c034bf2aabf5277298a999db36a6f1954a7ab3ed7647af5cb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4941675528e711794fd449cce8e8dd39976205e2c4c7c72273d78bbc3ff250b"
    sha256 cellar: :any_skip_relocation, ventura:        "7effdc2f19283abb462759955eb1893ee5906e57ca2507119dcaab44ff1fa4d7"
    sha256 cellar: :any_skip_relocation, monterey:       "472b2584ebc1d61dbc61477a8e863458beebe4cf2326984b64ec9d5a29d309a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370a0f534d71e07e648c50feb31516b7f9b7dd03c5857c33925492337ef9d834"
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