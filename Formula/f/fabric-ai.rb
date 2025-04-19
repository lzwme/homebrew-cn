class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.173.tar.gz"
  sha256 "07b2fed18e7c2f9be3bd94eb9ca80e70c39b3147617ff30da5357ace21958cf6"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0e0950976ed301579d1321880325912289bce2c8b77fc63eb02c267451b030"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0e0950976ed301579d1321880325912289bce2c8b77fc63eb02c267451b030"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae0e0950976ed301579d1321880325912289bce2c8b77fc63eb02c267451b030"
    sha256 cellar: :any_skip_relocation, sonoma:        "e45b2f19240b551223c81fe91d8d43e07bd1b78069fd0fd5a5d769d960f5f102"
    sha256 cellar: :any_skip_relocation, ventura:       "e45b2f19240b551223c81fe91d8d43e07bd1b78069fd0fd5a5d769d960f5f102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ccd8af80fc82711a09046ee9dae04b4baa7970a671ceb9cf46755f8964f124"
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