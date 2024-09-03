class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.62.tar.gz"
  sha256 "df8f7edd11764e1304a69e913fecca9106e95184623b98b396eea6f6fdbb33c6"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a84ce8789eb3762257b89b73f0a8e74245949f7b4382e07e660f22a2409fac40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a84ce8789eb3762257b89b73f0a8e74245949f7b4382e07e660f22a2409fac40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84ce8789eb3762257b89b73f0a8e74245949f7b4382e07e660f22a2409fac40"
    sha256 cellar: :any_skip_relocation, sonoma:         "86af176bd34784bc79771041bbeecb396edcab90b69ca4f559c4acc5af009cf6"
    sha256 cellar: :any_skip_relocation, ventura:        "95e684cce313fe3eda13629525de33077e515b2a1091beea564cf55aa2e6a18e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd6790a998c68a2f41e7ea8c85d8556212b42d49034bac502421817c4343b1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234f438477806d3148ad8b98bb39366c1287de20f7dd15e67a45aa097a1c32c7"
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