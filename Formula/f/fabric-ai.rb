class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.211.tar.gz"
  sha256 "c5f35cdecbe20beda37cf0f555baedafa930667c328f9dcf141c45663d74dceb"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0ab18a8ba4ab294664465f9e9b0abc4e546d942242af648d91a020b9fd423f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0ab18a8ba4ab294664465f9e9b0abc4e546d942242af648d91a020b9fd423f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a0ab18a8ba4ab294664465f9e9b0abc4e546d942242af648d91a020b9fd423f"
    sha256 cellar: :any_skip_relocation, sonoma:        "efc148d1efd1ff468ce901c2b4d2a77460488909cad3d8994fb9074bf2ec057b"
    sha256 cellar: :any_skip_relocation, ventura:       "efc148d1efd1ff468ce901c2b4d2a77460488909cad3d8994fb9074bf2ec057b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1f1227b84320cd149223700d8ddcbfb6bf4fe774b7a7fd06d0475dcaf23754"
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