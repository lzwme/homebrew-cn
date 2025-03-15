class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.9",
      revision: "2db9ba4e6bf77077a3f546e85c981dc21bbaf03b"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f133249f8dc2a801cdb586f0799d414124d14aca25efdc407acc52586ea2ed2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f133249f8dc2a801cdb586f0799d414124d14aca25efdc407acc52586ea2ed2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f133249f8dc2a801cdb586f0799d414124d14aca25efdc407acc52586ea2ed2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5071dc7522ab0623124af82fa229e728d17819ff778736bcfc1d1a8c6aba6e0a"
    sha256 cellar: :any_skip_relocation, ventura:       "5071dc7522ab0623124af82fa229e728d17819ff778736bcfc1d1a8c6aba6e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db08897ed660a47e550d2920ae2f2d831d5e3210b9f839923823201c48fbfc1"
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