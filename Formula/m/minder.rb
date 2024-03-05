class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.32.tar.gz"
  sha256 "8405ebefeb0555061a1faefcc791178ba4536c553f9a2b546f1f77923d6747d5"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c41787f5f009272e7e5270f1b624c8286fd5909b17d55acd1cab9a06880ca4c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4949b0ab11d5f452ff5c20558a15d2b621cbba5e42aff91d094e6d0fff882e15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5229d2b2e6308f88fac03d7b01861f8c1b1cc539820b89cdff1565d9601d1260"
    sha256 cellar: :any_skip_relocation, sonoma:         "906f4a1aef3b82578f0d9fe427dee2c1098684d221d377045e26ad99368a134a"
    sha256 cellar: :any_skip_relocation, ventura:        "4c4cf35661db1dfa072e62ae197f38717fa78642bbf85106d83ab2e43127b79d"
    sha256 cellar: :any_skip_relocation, monterey:       "886facf49c0caabb1565563e262de9c8824d065be22dfff4b574563fbb72d05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d8a351e8d2539b13fd68c214dd404e5e04411dda90cbc8f75f66693d7b4bb2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end