class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.221.tar.gz"
  sha256 "3e6fcda42b4eba0a8b5ae8d08426ea46905375bbf23266edf5035f475956d6b5"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e56b27c5bacf0e0f4ce60182aa437c44463d6960f1275a1e2cb889fa03a0166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e56b27c5bacf0e0f4ce60182aa437c44463d6960f1275a1e2cb889fa03a0166"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e56b27c5bacf0e0f4ce60182aa437c44463d6960f1275a1e2cb889fa03a0166"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb21d838fd00fe8828c08532e9019ba783e94b4238915c00c18accb9d84b3bf"
    sha256 cellar: :any_skip_relocation, ventura:       "9fb21d838fd00fe8828c08532e9019ba783e94b4238915c00c18accb9d84b3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd1b74fb952d29aa0b0000129ecbdb7f78929b3ff2461029778006ad8eaa398"
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