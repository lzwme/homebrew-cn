class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.191.tar.gz"
  sha256 "4c08cf8b8ee0663e4d344a484306227a29b628c96d125dbefd18182910957feb"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dabf87679bf6e03a802b09af81188bc5bbda67a52153eb3aa5a2e435788604d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "967fa82d7faa7f51eca4d41e763b60a0d85a89ab736f957f9bd4c180d8dd4ac6"
    sha256 cellar: :any_skip_relocation, ventura:       "967fa82d7faa7f51eca4d41e763b60a0d85a89ab736f957f9bd4c180d8dd4ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21653dfe435885d076f1664f785d1d205d0228d62382929ee332f5ed4368ec72"
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