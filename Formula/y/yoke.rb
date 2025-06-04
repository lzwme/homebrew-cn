class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.13.3",
      revision: "bf1ecadb3ffebcf19dff3a5b7d3b5d1375ca0110"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2d21e52cefed8f0ff46e99dc338adfc0156c7db21f30f9e3545bb4a1c2fce4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a676412d01d8fcbbca2459b8d8bfee3f3a6a73bbf7180d0785ce5e42e60a4cbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4240c7ed623aa6fe33caf28ddfc6e1d8c6e2f9dba255221bf9646100d07a2d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "78c554f650a486c7352dea1eb380cbc1162f2258d5a219ba80928c2361690ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "24e93e424dae19e2ce45d0ae4dc34cc578fb11dff318a3ad024eb5176e32233d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40d825b6e3366fd2b195fcee9904d80a6bf742b8843be70cad1142c3e5dd216e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94c9e2a691db7c9ded3f205044bc4925b260583ad0b2a8091e36d2b470ee23f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end