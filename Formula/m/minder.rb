class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.77.tar.gz"
  sha256 "195952225d495608ed6d67b39df63763eadd58eb45c835515f5a2c61162812f6"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b3541881f61892d6dff02708a1ec57811799dba3a9bec9810870413089cdca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b3541881f61892d6dff02708a1ec57811799dba3a9bec9810870413089cdca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53b3541881f61892d6dff02708a1ec57811799dba3a9bec9810870413089cdca"
    sha256 cellar: :any_skip_relocation, sonoma:        "6780f7f17764b76e39496896b6e0febb856102f8e9b6ecfafb0b5eb48e472de3"
    sha256 cellar: :any_skip_relocation, ventura:       "0d85fc7007c836c926906f654fa09488de588862e5ed20eea7c4ba6711a72bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c671bcc6ea4d392f7437c5e9b77bef714068ba3e396d74afdf62271ca083c813"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end