class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.33.1",
      revision: "f2c9122018ea1e26677db2fe4f7d5cc4bd1890a0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d4406d118e6a6a3cde126a25cbbb8a690e16a596a34350dfdd62d078a05a31f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b968c143405cc2931d3222ade5bebd73d4e26ea379b48dd785b629aa4213a11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0072414b67e39aabf6297ff862077e1575787aedf63b56505006154bc2211ef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e6f903111d69e4af82ca5d02eedbf55ae3666a5cbcce7c9558a478038e5cfd0"
    sha256 cellar: :any_skip_relocation, ventura:        "43e901682651e43962d2a20643ca31d063f711ed55d650edc366ee19bde553b6"
    sha256 cellar: :any_skip_relocation, monterey:       "873b0c55b6b9a074a6ebfa794799a9d774843e04fe62b39a06efe8f7b365429f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daff3f82b2cd5e990b29bcfd171655186e4e1ffbe5fb92d7cd097f97a7546af8"
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