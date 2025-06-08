class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.13.5",
      revision: "74130989653d7b54749aa1c75aefe476857918ad"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cdee8b5300fd490ed8b4f24b64e39a9ecac3bc4ebb610e38b7af50fd03bf315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89105a37507a6c20680c4fd17b6dd9cd501b218d1373b7aea8b823f087e1d9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2ca7240dcaac2d415b4d2df4541e577a0b0b55bff55eae8cd12655b40d4ad0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc7351b4faa9ab3707e43ce91e4fbbc42e58cc8e1b630691d64cb2abe0e808d"
    sha256 cellar: :any_skip_relocation, ventura:       "516fb720a417fac1fd074f5112c4668d46d7df92784e72f4505cde60af126f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ba708910147e80dc2634c71fc22b758a5eec6207d11ce1a974be8fc2e4f0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c28248e50d43083eb7c9a781c816ad40d06038f517ca9cdfdb2e919cdbf90b"
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