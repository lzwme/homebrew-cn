class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.23.0",
      revision: "58a1823a0d50dd2b7cfaab5f25bfba8db4dcd7a5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bffb7346d411072ff3d34d4a38794241f77cf929b1d172073bbbaec9727235ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a960b5e56798deb97a902caef743cf1215c828aee74ca791606a6a4f1b089af7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a255ad96dbd3ac8cbf64b7f06a2b0c4a65d6ff1e9875d920ea19aae99565305"
    sha256 cellar: :any_skip_relocation, ventura:        "cf922af517e76a73fd3d29a622157f66b67fe7147849932d62f4cd0702dceb82"
    sha256 cellar: :any_skip_relocation, monterey:       "d68d03360c296cfc4219172bd057d2054bcb1b64ab91586fa5e3eba9eb5834d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "84a794a06412db477f5f13a18ad04fb5529d3c77479a2aadce5d28a3d4356176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368eef800b6027e329437f92aee117dc2d629633d6dcffd8fa759c88848452bc"
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