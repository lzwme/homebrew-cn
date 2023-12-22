class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.22.tar.gz"
  sha256 "15f5bcdef9fe5be4d2b951ef4aa1dafdb7ef9def12e0b752301e0565b113a4fd"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "384198c7c30ea7f20dec600add44bea3b1033d97d011819052b430afdee6e64d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bd299c214dfb8d33a5252872b2857444c7c98891b0be62ce11376ca9dc3f735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec96af50303d757cc5914db5819478e7367f5baf1ed6b282ff2985cd16af1c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d5f0b64b4e4ee27b3de4c0a8f8180d4f1cf58546963c82d9327eefd01fd4296"
    sha256 cellar: :any_skip_relocation, ventura:        "0c8a3c0b4062c1f215cf959f7e1f50555dd0248fe50150eb5b683502177e5a68"
    sha256 cellar: :any_skip_relocation, monterey:       "42ce73e9ab4d86d66eb10e78ef0cd79edcc103c81d5fd15c68c9cdf2c6541cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1b7cc382592d44fc7c27a581642b954aa76d732ad6ba0b9a297b38f7cf0674"
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