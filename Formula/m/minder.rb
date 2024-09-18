class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.63.tar.gz"
  sha256 "b7c061d48b2763f2d9d7fe70384bb9e75edc37063b8b3c832afc29eec7ab4306"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b49835e75a99de2c9d7456dff558ce5dfb92985c580149e223494a211675b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b49835e75a99de2c9d7456dff558ce5dfb92985c580149e223494a211675b2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b49835e75a99de2c9d7456dff558ce5dfb92985c580149e223494a211675b2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4f00673c38a813aa1ddcee6884ec491a9dbcb3d9a0f1e57b71ebbec17d80e7"
    sha256 cellar: :any_skip_relocation, ventura:       "29415c2a0999eea596c396aa2e1abbb3a17bead32cefd08ea8cc8701db2a16c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0cc1c3799360c1961e0b5770e21cbd66e4cd3f262bf7d49f06298aeefc5c6f"
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