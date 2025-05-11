class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.187.tar.gz"
  sha256 "8fd72bce8929735586f475037c9517dea058efb08d371976805b88d3f90a62cd"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a23e09110127e9fc4fd37d8e6652ede363b8e8c5decbe72fc9648bccba6a1eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23e09110127e9fc4fd37d8e6652ede363b8e8c5decbe72fc9648bccba6a1eef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a23e09110127e9fc4fd37d8e6652ede363b8e8c5decbe72fc9648bccba6a1eef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d50764b2ab10315e410f2781943021e507f48a6f4673f7bf8351106791ba2d43"
    sha256 cellar: :any_skip_relocation, ventura:       "d50764b2ab10315e410f2781943021e507f48a6f4673f7bf8351106791ba2d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee351914d9ab336f52757f5d9afacd051c4c06f7d8b840b9b0d43f5c395bd915"
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