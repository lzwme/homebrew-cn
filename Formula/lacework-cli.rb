class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.27.2",
      revision: "bc2987f7419b1b6d5e9c9c78c52025bbb6cdf731"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af5a7e1e227c189e23652e039d512c14348086d4e855b0600a5889443ad492ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b6a68916167fd70cefbca9c0cb370d75c147e34c5a921ed7480296cd5887c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a7f1f280545fc734b5f6695e94324a0514ac8f7d3ba2ffba02d18f326add7ef"
    sha256 cellar: :any_skip_relocation, ventura:        "0e99bf5ad1a1bd94311eb71558749a021f0ef4ce48b7c1db82859b56d53c75ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b28b8f8ddbc83625f42d6860143f27b013fca4fc7f392bbc5327094a7cb98e67"
    sha256 cellar: :any_skip_relocation, big_sur:        "e95d0d09c8f6e2afe2b141a1b476e935fb7347166193e9df581972ab4a58a5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efe4f67b9a5f492aa6f30f1a605603034d82593a2a7255da2b62ce24670ba84"
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