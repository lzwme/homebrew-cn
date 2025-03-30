class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.166.tar.gz"
  sha256 "40278077a7d5dc9a5bf060681e114fd9414241636f47626f3ae7814d26fc439a"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10555a18b3645bc03c47c962df9c7733fee1144a0283df8787f8cea7f7a6b1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10555a18b3645bc03c47c962df9c7733fee1144a0283df8787f8cea7f7a6b1e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10555a18b3645bc03c47c962df9c7733fee1144a0283df8787f8cea7f7a6b1e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "764a267fa56c5aaa2b83a568867836e1282bc148bbeedd2041e94d43d4537fe0"
    sha256 cellar: :any_skip_relocation, ventura:       "764a267fa56c5aaa2b83a568867836e1282bc148bbeedd2041e94d43d4537fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9d51315340f124a4e74b8d6389c94159c133abc703c67d0937fe023a7261e6"
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