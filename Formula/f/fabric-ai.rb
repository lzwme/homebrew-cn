class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.183.tar.gz"
  sha256 "7c293716cb615a2ba7c26638c7dd16c335b2e145d3acbae72145f224fe8d6fb9"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74c2d6cf911219ddbf70649038dac84b99cde082711eeb37049784a3e3ae9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74c2d6cf911219ddbf70649038dac84b99cde082711eeb37049784a3e3ae9fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c74c2d6cf911219ddbf70649038dac84b99cde082711eeb37049784a3e3ae9fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9430fb6741b59d3ccc3e11f24f8ccec5d81e5ebb1229a9345d03470855edf5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "9430fb6741b59d3ccc3e11f24f8ccec5d81e5ebb1229a9345d03470855edf5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d2cfb098c35389615ee5e4c6f1c6b9d8a5f1aa1e397381957e74dfd90b998b"
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