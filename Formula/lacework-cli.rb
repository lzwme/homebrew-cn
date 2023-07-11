class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.27.0",
      revision: "5cb196f1700c9bceb88dc86c8d78038e51a78400"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9698f75b03c31ba0799a648e748912edb185c26165b2bd60a3cacfe07bc78c8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8cf63e4c5becef387ed0766725492204a3c3721bd9fd3d1036216bc7e897ced"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faf4b1af8187c62166369073324e9dda320bf496ba6654be0ff5345c42f86325"
    sha256 cellar: :any_skip_relocation, ventura:        "ee90de3e4a7a23a655177c79717bdb98f1c05bb3005145b54eb90e84696a5729"
    sha256 cellar: :any_skip_relocation, monterey:       "ee62338e7155d0871722a9341e42f44f4df83f6644ec5bd151dac19db10c489a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7669e21c6d547b274ec588e0665c23492192f52a15e6bcfaeb81579e20ff361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6cfd000df159bb8d70bb91f9175a3ec6f27a1d15d6c883e6b95889713b77c7"
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