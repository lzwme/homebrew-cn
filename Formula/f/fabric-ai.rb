class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.164.tar.gz"
  sha256 "481718a599663fe5d4ea00aea6e53c81f64183a1c551535573d8faf9b8f3bb67"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280653969b103a2a9f7e9a156d9db14908e6ecab4a3f6f4082cbe7d8d7780bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280653969b103a2a9f7e9a156d9db14908e6ecab4a3f6f4082cbe7d8d7780bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "280653969b103a2a9f7e9a156d9db14908e6ecab4a3f6f4082cbe7d8d7780bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2467ae0986a50c6aff4ca0bd1d40aecbf7ddb3ed023d7bb76313ed28527f85"
    sha256 cellar: :any_skip_relocation, ventura:       "8a2467ae0986a50c6aff4ca0bd1d40aecbf7ddb3ed023d7bb76313ed28527f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee8136006a4cc282352a0433ef2d302e82f557a62a179773dee52e454687db3"
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