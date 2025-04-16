class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.171.tar.gz"
  sha256 "6b2c59c3f97f4930e823b94aaaff85c4943353fdf7f0533e056014b462339764"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb206b9588935135706733bc8f963cdb3f974232b3bf48c18ed8b3fbfc7f059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb206b9588935135706733bc8f963cdb3f974232b3bf48c18ed8b3fbfc7f059"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffb206b9588935135706733bc8f963cdb3f974232b3bf48c18ed8b3fbfc7f059"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff6ab40bf70dff0212f41d03ebe26db4d6cefd64910031507fa3b39394a59e1"
    sha256 cellar: :any_skip_relocation, ventura:       "aff6ab40bf70dff0212f41d03ebe26db4d6cefd64910031507fa3b39394a59e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c99cc38788ee6a7758c442221167c2058b037dcbf0c7bbe6491ab8efa70ce8a"
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