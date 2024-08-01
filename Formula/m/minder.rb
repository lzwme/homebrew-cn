class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.57.tar.gz"
  sha256 "e26fb4b5d8ae9f109aaf148051a83a31a2de6dac50fa329d4a5eafc1e342d9bf"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3701b36444c28085482c1c22e7d7ac2478e157f2946a1fe85d878f0e7b85da48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90c1d2fa72285dc64df6709505aa3c7776c38a136338467ddf767020c7a1a607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3527ecf7749faafa140639d480a8fe16247e0f2759a95d5629f0a97caa945942"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdd2581bb6b9e999b3738b89706d96e2517d23f4e7e11299af08d4dcf667fbbc"
    sha256 cellar: :any_skip_relocation, ventura:        "f12c4b04a5386d362d301253207d6c805a7fdcc804f3bd1fe90c0a15e2201e91"
    sha256 cellar: :any_skip_relocation, monterey:       "1c17f43e16eb66f1deee6dc6cc56263a03a8508382765704f80a68801a412312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20825e7a23ea504593b2e3e9df75037824da5368e8a2da99180443c5aa95b0fd"
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