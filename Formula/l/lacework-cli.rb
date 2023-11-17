class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.40.0",
      revision: "cebfc2528bb4ef08d562009ea142883418fb1bd9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0030d83a8e7b7869b95eed9bffa2c7bd2c59f06d560d71b9bca93c6402dd4d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6bb45adb16a19ee96e40aa0b417ceaa4ec3d9e56ed5630eeedec919cce0afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa279b78b8ecc3a3430170021fff050b4496ddf370ba8a6d62cbe4a19e508635"
    sha256 cellar: :any_skip_relocation, sonoma:         "23020b4645d16bc59b9264ac42197b44e7b7a3fadeb07aab37094b7ddc68e43a"
    sha256 cellar: :any_skip_relocation, ventura:        "df73c2891bc386e517cbe7530877dceb1a3d5a224cadac489a60a989aae8d9fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e10feaa8bd915ba501376f5e4812908d11df91f888a6e2259a02703679eb5229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02dbe4db2a2c9e23e3b6fab026389a639c04a7f54a424ce3d2ba2cb970751cbd"
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