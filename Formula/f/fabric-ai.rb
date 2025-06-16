class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.204.tar.gz"
  sha256 "478c0fcef75fcd6cc18cfa39e1308d426ae6e73f87245547cee4bb30376066c3"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efcbcd6afdb403c29465d62a950a611a5ee012cd8878d0699ccf1bc3a8724538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efcbcd6afdb403c29465d62a950a611a5ee012cd8878d0699ccf1bc3a8724538"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efcbcd6afdb403c29465d62a950a611a5ee012cd8878d0699ccf1bc3a8724538"
    sha256 cellar: :any_skip_relocation, sonoma:        "149f173ca6369c3d23968311d9b40cb73dee2ad9ac5aef97110d783602fd5c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "149f173ca6369c3d23968311d9b40cb73dee2ad9ac5aef97110d783602fd5c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8a52893933c3e4d2455b0b02623e31da66e2e6d8d1509a13cfe744770e360e"
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