class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.36.0",
      revision: "2d45f6c1f6999a3cca2dc835b668f58ca11ce93f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8c645be72c1196d0173d0df8cd00174cf2381df39bb8d31398eee2d250025f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b6e27034c53db0ca76964c916962f77590ffb91bdfef0678837d4c8bad29e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d143f3cd18ced50af1a936d120caa705c3f27cb14da72980662e34ba232e8b10"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fab19d03ebeab9ca4cbc1247a6573fc2a40a67ed356f926e5e7244737b46bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "7f12bfd2026b47f9d8f8d0bdb1795ef5a84b1cb7f1a0ff5fed1ab5a3b9375094"
    sha256 cellar: :any_skip_relocation, monterey:       "a12bc251ec00c20ace79d9ef56c3e2a52d5942379b615d5949c24f3383a43460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0245b58fb1e96b97fb2245a58c339f57af8a5a0891975885bc4dd7b59c2bade9"
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