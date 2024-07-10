class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.54.tar.gz"
  sha256 "70a9481fa5a91ce93a00a7f32d2d5e985d6154608ec19ff404bb6e0dfa748c16"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f5a1e7142750c21bbf32709fe67528687310e3a3beadba613590817d795d531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804afcab52a34c74f24be1add1cdc7f29f1cd0aef847f976c7df0ab853eca30b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf4395a9b84e3e69c030711ddc4ee7afc4b3bbb002910e540b28b97752b1285"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6b20afefcaf6cdff4ca152fddd1eb90eec2e648df4e52c9bd01ae4c121ceb2a"
    sha256 cellar: :any_skip_relocation, ventura:        "04d7fdd0262a3842f3b32db06812b02e2958484e79a60fbdb64d0869e8f66932"
    sha256 cellar: :any_skip_relocation, monterey:       "780e68791822c40fbc737577ef4d7d0737347671338d670bd152d5a4e9e6cda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bcbd0e088a0925da5fe4457c97c34788b8248ed0061813cb276b06e30bbe9b"
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