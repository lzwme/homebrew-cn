class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.39.tar.gz"
  sha256 "d7b9c48d5247c1733706e1418e5bf6d41d81cf0d3460ddd3098804e09417980d"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "506ae01dd242f022da4b601d72b753b4df9cdee9857b599457a63ccb881136a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b9ba5d317288aed61d7108a89436838ce4be9ce6f5f7edf3aafe87b232d20f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10761b304eee631d946d1f6697acb17f169677673e47dee9f52747489cf7fa29"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ebdada31f41730a380bec8882baaf46b91ab287e60d58f04c0d50bc49e04ab0"
    sha256 cellar: :any_skip_relocation, ventura:        "9066f392c5db72c6a0878ad76ccda20a484ecf1d9fb5bf08c47b6a628da4143b"
    sha256 cellar: :any_skip_relocation, monterey:       "b315af6e397d69682b265d3aa201b3905c65f6f820b439d4eb67404cc8244f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f8ee30afedf3790929ca6e67602f2284925559753f3ebd2b9157bb7590c98a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
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