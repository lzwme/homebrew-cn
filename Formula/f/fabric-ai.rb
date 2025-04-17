class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.172.tar.gz"
  sha256 "af191e625f7efcf297caf1fd608d1b5965dc8a5543a549a398dfa0d479db056c"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a4672ff5f60b0e22979d34a9759ca2998beebe412aba13d532d8bfc4fced31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a4672ff5f60b0e22979d34a9759ca2998beebe412aba13d532d8bfc4fced31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2a4672ff5f60b0e22979d34a9759ca2998beebe412aba13d532d8bfc4fced31"
    sha256 cellar: :any_skip_relocation, sonoma:        "873bd5b9f9170f2238759457fb4e82594c1d6070b92c0210fa1cf0ea8fce06c3"
    sha256 cellar: :any_skip_relocation, ventura:       "873bd5b9f9170f2238759457fb4e82594c1d6070b92c0210fa1cf0ea8fce06c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb90dcd1c0b033e915e8269dffa54e4e15ec3d9494610e073901eb6efc8b6d79"
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