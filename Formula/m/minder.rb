class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.59.tar.gz"
  sha256 "32d906ab675e5f4f272aa668bc8473423e4b3afe376031a90dc954a5892dffc3"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5babc77f8fa82ffe1035ffba469a60295945a19c54f4639a8df2604e25d5a2dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5babc77f8fa82ffe1035ffba469a60295945a19c54f4639a8df2604e25d5a2dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5babc77f8fa82ffe1035ffba469a60295945a19c54f4639a8df2604e25d5a2dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "442e0c336d2cb52db0ed952cef5ac5910dd61eac8a9fb456f69dfbebb67a6a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3aff67142a2d935a06cb3aa346185bc94944b45e68e558e225b8e3546d5beb"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9a6b86b2537678f534763a00638386d5ad5cc16e28fdc1988c14e38499eeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac85f895d0ef7b1714656bab94de610298153bdcdc51a87af2b7aeba98397501"
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