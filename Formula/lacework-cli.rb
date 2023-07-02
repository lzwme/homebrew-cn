class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.25.0",
      revision: "f8c6e64671a8404976baddf6d9191688bd6e440d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3faa81d0137eea53306ac958e3ce792f2f86a6f2b99ee886c822391a468ffc0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6906e8f532f69201506f0eebecdad1604859436ab2c64a9492a94993f079cdeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1359936e9bc0a0e295108bbf6ea5432e48f500c3c30367e6100c8607367c0a7f"
    sha256 cellar: :any_skip_relocation, ventura:        "8cb9bc6569ba61fbec5f096eaf882eb701aea621096d2e6ae704c3667669dbeb"
    sha256 cellar: :any_skip_relocation, monterey:       "95bf812eb03c45b6dda6587a40a9194d6e269503c5ef103a0e6c1ca4db586f7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "992c8bbd970d86b7f3a9a5b3d8faba5065980c6fd3d0e1d2b567e7cb863a422e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df5124901fd4b7e2454bc796b4b34b82470150e485a18231c2f88ef2ed85535e"
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