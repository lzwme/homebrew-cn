class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.213.tar.gz"
  sha256 "6a90166b97df65d8a083ee7341bcd98e687ac70b33b8bc361df0b8c1949880e0"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d20c02bd45e775cd9df022a8d77da5473685fec45722aea38cf7010a5cd53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d20c02bd45e775cd9df022a8d77da5473685fec45722aea38cf7010a5cd53b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04d20c02bd45e775cd9df022a8d77da5473685fec45722aea38cf7010a5cd53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea7b59e207dc988091ed3415d0f80fbbdc99934fd39c7c9eea4022f20890c33f"
    sha256 cellar: :any_skip_relocation, ventura:       "ea7b59e207dc988091ed3415d0f80fbbdc99934fd39c7c9eea4022f20890c33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb25154535aef2e64a5d5a93759be549953e28ac597129a4b02d762a6cbc76e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end