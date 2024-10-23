class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.69.tar.gz"
  sha256 "fe0dfe45a5346e39a38e0ef0a1dc369cb2cf6226d07c5d601f6d970857c687a9"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ef99aeaa9c5bf7ef204492de342d2f3dac41e8b6537f90065ace1b5ad62d1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef99aeaa9c5bf7ef204492de342d2f3dac41e8b6537f90065ace1b5ad62d1cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ef99aeaa9c5bf7ef204492de342d2f3dac41e8b6537f90065ace1b5ad62d1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "15cb44b59e19ecb64f07c887e3994c1890bc8eff772d601b450b56463c8a39f2"
    sha256 cellar: :any_skip_relocation, ventura:       "b8ef745cfa46b5e8852cfc8e275b779694b03451b3d96af70257246aed4d1f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2072cdc0e78a91239ffa4291b542f079bdcded17ed190a04129b4a1045856c10"
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