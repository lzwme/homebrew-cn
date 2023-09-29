class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.33.2",
      revision: "97991b54374e4a4e143e2f8f5b2e1f910b3c6295"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ef4e51a447d8de81836d5cb243403da9eb503b33237ab216f88a3b2966de619"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5703457ae760d1b838c7eaeb2da81f4f7d5ead5cbe714d7c49ba01d36d798e62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d3822739a6148d6915154b79237e21e13989e47270d7349e6949f2f0b5d8602"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbc4c0bd99adbe1cc232d2f3a32bf32e89c28fc67e1bdaaea7e3285e6b603fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "f878ec3b31a445fcc7610edc25db97fbd22ac8e98cb73af07b0ce5e6d04c0f0e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0dcce2886f2397a559ba862aaa6de76ca6dc52c5efe9eed17fd8d4673b2620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f704f9d6190d48f77075379a02db7154d5d4006ce941f5a3083c084795f9cbc"
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