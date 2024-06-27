class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.53.tar.gz"
  sha256 "89900ef07674bcae174ffc218c45b53bfbb225ed21393db59658449810fafdd5"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91459e8f79779c3fb25a134504e6d5fa83bf1fe223c7371fc489b83567eda3f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91deae632e21cc2fbdec5ee349705b265263880279219b717935f63a70904c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f037700cfeaba68d316d5d6c56879470fa2a7de9488cf24459dd6bfb05a57485"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d35cf588851c857a7f28c464e84b43a958e76737fd696b8ecffdd4997469a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "07fd5011ef47ac7518bf53169f40abcd55c99b242205de7e196d0119ecc8dcab"
    sha256 cellar: :any_skip_relocation, monterey:       "9dc5fed9479d3640385567d22d0cc8fc7f761a5622b10fa78a6a210116a0b4b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9060b51385f7a3ca0067201f7be57df74a98325881a5d9544ec59a31c60dab00"
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