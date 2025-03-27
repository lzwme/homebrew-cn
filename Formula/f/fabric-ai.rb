class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.165.tar.gz"
  sha256 "142ae04f1e58467ee5a8af366a5b0264c4de0c1ac53d4ffa1bdb8c116ec3daed"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e1746d4d41ca17e2b842023723160b1839e11a0be4b1da22f686e3656c63b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e1746d4d41ca17e2b842023723160b1839e11a0be4b1da22f686e3656c63b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e1746d4d41ca17e2b842023723160b1839e11a0be4b1da22f686e3656c63b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba1df05adbcb6824bd76879ed66b75f1ba16dadae54454b5dfc75307d3262663"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1df05adbcb6824bd76879ed66b75f1ba16dadae54454b5dfc75307d3262663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a4a74fbd8106fd37d8344119570e729157b8555fccad7680c454f9a7678b3c"
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