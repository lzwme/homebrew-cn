class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.196.tar.gz"
  sha256 "0d75dbdf7e7750189e1fdeaefbde5dca396b67baaa89dff0ca34be4a67666d8e"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bcfa79973bc6b93c5c197bc572bd7c136dfd1977d9bc53acef9cf0c620cb065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bcfa79973bc6b93c5c197bc572bd7c136dfd1977d9bc53acef9cf0c620cb065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bcfa79973bc6b93c5c197bc572bd7c136dfd1977d9bc53acef9cf0c620cb065"
    sha256 cellar: :any_skip_relocation, sonoma:        "694abc5bdc01730a7a2e620f7cb41b29f86f51f268f2e1534f5cd8cdd6dba0fc"
    sha256 cellar: :any_skip_relocation, ventura:       "694abc5bdc01730a7a2e620f7cb41b29f86f51f268f2e1534f5cd8cdd6dba0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1910afc457518c99ff944237740b02fa9bc54100f9f582547fe9fa7da1519a"
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