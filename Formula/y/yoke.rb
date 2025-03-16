class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.10",
      revision: "fcec4173500f3e943c212a55f3ecc9e97b17864e"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b15e80975a49acaad40748a892d494f264a3e21159332ae51eaff0ed852df919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37daa7f413858b6d70ed610ed0742a582c81d1ebd25b13ed463e15c4b958a95d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb983660a6f1625b415ce0dd72c85bcd24b7bc4f3553134fe31fba852b1e4864"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c50e8238556fb74c6739fee4ca018af1f103d2d2e1257cdd8961a2d10546734"
    sha256 cellar: :any_skip_relocation, ventura:       "eb006960d76e42bbc3f1b8ce2b3a6e3ddfb2c7bdfb5fbdb20b65b541b42be724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480ddeb8103cd0f4705a2081fabd789f0fd888cae072624d710fd0118f1e8263"
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