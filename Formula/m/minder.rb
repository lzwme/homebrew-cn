class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.46.tar.gz"
  sha256 "3c724f842ab08c71902d85bd2a68c89c2e99862a2e9438e5db73193b709d02b2"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01a0d74ab2248ed070ac51aa7b7a3095b04cd574e391db497b4bcf1cd1dde4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99a82c508022af6614e6c1e8c729266b10eaa7fa46d45eef6b1ef429e332dbeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40df90bace20c73afee89e627b3a7e90f6375ad5f7e10b13fe39cb10a7fc744a"
    sha256 cellar: :any_skip_relocation, sonoma:         "05341ad200a38e857826654ecbcb280ade1d26cdd85c49790308793b6c6eb4e7"
    sha256 cellar: :any_skip_relocation, ventura:        "805dec969a18761b04d0d2e85c47a18ff25cc4bbbcf84449f6b61ccbed13a46c"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb309724ec45591e393c26bca79126271d2a3db75c0805a6a81279eb6b24c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f362e16657616d9173f4b56c20c1d1afd72fbe7fcd57b2797f90254394d4b98"
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