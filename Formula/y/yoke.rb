class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.5",
      revision: "a634f436e7e47bb861c2614021c79c21642fad4e"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b170ab726670fb7ca59c82f169c7904d7ef0f3ddb73a16bde283352ca89966b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b170ab726670fb7ca59c82f169c7904d7ef0f3ddb73a16bde283352ca89966b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b170ab726670fb7ca59c82f169c7904d7ef0f3ddb73a16bde283352ca89966b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c78438149ef6b6cc23cf2a363603128cb0fa3cd7d1ee17dcadb971ab88f629"
    sha256 cellar: :any_skip_relocation, ventura:       "b8c78438149ef6b6cc23cf2a363603128cb0fa3cd7d1ee17dcadb971ab88f629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d33fb63035ca3ca175709f29b5ee9e8ef225c06ba9851bdf8943c159b71751"
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