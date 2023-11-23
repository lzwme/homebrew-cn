class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.40.2",
      revision: "fd3528a1115623ec4f2fbcc6588de1d58e1b6347"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b48d96f9b8d27770c280717c9a1d13d29b16ceef7c24c810527db1d34dc6c0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aeccfb8ca06eab566bdb75a8afc62a71e0a3eca90999c79e80edd5e7a80768c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219bf5f2909a3c18dfe7c31eee3d0d241116735457a45cf16597603c98f9a3eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ff1ff377e822eb999d3e9cd07ca631956c022f707c7b2a072076b26cb752f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d50e8f31adfdc711a85c0023ddd4cf32295657f2cda09f848f316b17f275739"
    sha256 cellar: :any_skip_relocation, monterey:       "be2b56798b5b0d5ef2f8dda8dba6cd35e0d123988a4666afda7a74e12fb7108a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba6199c4c812f1fef00808ceadaff460e37b1b34869640476116778f516d136"
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