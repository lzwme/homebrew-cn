class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.21.0",
      revision: "3ea444aacd88d75e2e2b48e22f328dd87e2f17c0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "833411e08a53d217437f850c9587590c3aca9c586f577afc61e00d65b77b88de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c307a35efe0e5cf97dd97d0a1a3d104842b3d697ad73218cb6ab95136345081f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04068047774f84445ebdd24b179e8e414633b771951eca727927eca85871b126"
    sha256 cellar: :any_skip_relocation, ventura:        "929536477e442408c26be62899cc6416a0a14241da18628fc18a4cc370830dff"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d441bd72adb494bf9815a213429b7bf7a829437681a05d435e16adc336c2a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ede52247ca6298142ff3f180d6bd33b09d6bc4ba7ab0c0068f84f9226205ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9bedcd7c89ce0cd6ff1b7cac2e9cfe0e523db3e720af91ec1574348f40e9c4"
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