class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.11.1",
      revision: "3bf54b631bbd96c844fb0f98032e97a957f82afa"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3885fde951e0da873ed4ded845d4f6c6543baaf0e1e36edf8c7761fb3a4debe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82599f96255690f1d3bd3fd6056bf66ef4489d59fcfca6d4227fb546892080b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c18a28437650fa0690a513f3ec187432d938c522fe3c024f32416820bfd50224"
    sha256 cellar: :any_skip_relocation, sonoma:        "16a5264ce8ef3cc1df9395068461d2b959fb6feffcd3cad44f3038344fbeaef7"
    sha256 cellar: :any_skip_relocation, ventura:       "f9e8a2ac556ed5e139abb3892db28143064d9320615ad1b0158a544a345a72b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5687a0d3bb2fd65c639d9a1b36d6b0b7b0d691d951d165df8243b19c18df1b"
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