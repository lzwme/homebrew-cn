class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.33.3",
      revision: "b796fbc13651a9f3b22e7832562b661b74680470"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d19d97acef3787d02dab5e9bd1ba47d18cbadc43bc5a841e1527f387771e1d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c1bd994b45d9d87011077b80148ff42975b748c0cfe075dfbe92a57b8d6d14d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc056e505f20680c82848650183a106c71b58fb96a2a22a9c6cf9b272e72c17"
    sha256 cellar: :any_skip_relocation, sonoma:         "79409cdfa95812d0cfbf9648a35148f7ba8e64d37a5e47a81b58b59c40a581ed"
    sha256 cellar: :any_skip_relocation, ventura:        "78f0ef60b48d2c9a2696efca907fa2fed3c9a3d792e0c86e0507839d29792f53"
    sha256 cellar: :any_skip_relocation, monterey:       "249303c372909f67c40eaf62338051c3548c302849346320cc573c050c12dd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f991cd0f89395cc982c63ae005f9b041141dd226505800082a8c624f62f2d1f"
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