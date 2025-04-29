class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.12.3",
      revision: "f6a7b8ab514014ec938af4677772e48eaa4f23f7"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51bd4327ad34e29eb8cfec0c0647fd78303afc68058e44ca931a63eeca3a89a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60aeefb82d74e42203ad09398b64c02db17b4483a6432dc6a8cf45b1081060b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9350c1e4e746c1a7068e29a772cf072a30fefa8a0627f9c7929acb958fa111b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7779fb03add02c77178a7dc0d33652eab3965f82757d3d6ca7d09a2cfad6b6b2"
    sha256 cellar: :any_skip_relocation, ventura:       "6dd40109506f6029d1fc2d71449b63ed2b94dcca6fe8fbc848fd1a30ffa10d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c68779bde35cd6ffdce912e8ef30bde89ed63e2bb01685e87d255d7302598901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "743d61bd0782e13a1a161ee0e67a4e3de0d70f58dd07ef1e846b15a3f910c351"
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