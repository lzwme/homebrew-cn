class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.170.tar.gz"
  sha256 "df8d5cb4217cd3589a14f05075d01327113b302e1f5b3b36de463beb8570dabe"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "552eb5a7e1f33b646e5b42603c3206bd51001e5a4a876d91ee0ed9a09a01a7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffb5ea01b83215a7c55c060a57da745d83f28e3d372a5aa52efeb920e0430f2"
    sha256 cellar: :any_skip_relocation, ventura:       "bffb5ea01b83215a7c55c060a57da745d83f28e3d372a5aa52efeb920e0430f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2c63b19567dbb3d095e5bcbdc193a461c73be178127f5ece31333bc93c093d"
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