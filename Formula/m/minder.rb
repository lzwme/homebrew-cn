class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.76.tar.gz"
  sha256 "c487a4ee788517604fdc17b6ed2093d26ae7f132255f3c9e063ce1c2b559d57e"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5216f71a18af8937cbfffdf5a6a3917194f39c6080395298037acd1f24109b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5216f71a18af8937cbfffdf5a6a3917194f39c6080395298037acd1f24109b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba5216f71a18af8937cbfffdf5a6a3917194f39c6080395298037acd1f24109b"
    sha256 cellar: :any_skip_relocation, sonoma:        "558bf6f698dd8814d41043ce24c23ed12f477cce12baaa362b2e6148e688d680"
    sha256 cellar: :any_skip_relocation, ventura:       "66dac59c9d27c97b245695108889f21a7f54026c1fdf7902745e800076872162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "297e25ae1a4617980bc672e2288ae92bc063fbea08111c0c638b8c73d61fcc9a"
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