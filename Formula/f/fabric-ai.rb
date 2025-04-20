class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.175.tar.gz"
  sha256 "c1283348f0353a0e5026857035f41120a2aecc7925bbb378766f4147222f02ab"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b29a0b3a2aae88f136140df79f182cefa8efa927e06e49c1ad0d8665c6ed932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b29a0b3a2aae88f136140df79f182cefa8efa927e06e49c1ad0d8665c6ed932"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b29a0b3a2aae88f136140df79f182cefa8efa927e06e49c1ad0d8665c6ed932"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8a1ebbce63df76e2cefd61c54815eed821304d38647cdd2d933c4a160c7600"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8a1ebbce63df76e2cefd61c54815eed821304d38647cdd2d933c4a160c7600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1c138f915b2573630e94ff26e52a529e9f1204164d05b1e2328f7bd8ed4a91"
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