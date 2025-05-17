class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.12.8",
      revision: "d5b9b81a0bc1edcfc725d31614b53b99e9d12989"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8e7ed3c8e5bdb197bf17848cb3711e1ff74ae2a27615e1512d9b61b08be45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db801821ffcc62e70471c153f3aabf2c9c7556fbc380b51ad4b9c44ca15c6f7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f96c32da090fad1768bff575938088b0593646656f5bf3ebd94a2526bff08da"
    sha256 cellar: :any_skip_relocation, sonoma:        "a07785aa1b97f8845653a637de1fad4b74d395f27a994376c4b967500ca8c980"
    sha256 cellar: :any_skip_relocation, ventura:       "873a58497bfb8c07f3312bd87c618a5349cd701000c750c7fcac12afc4c0ff55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25388a65ff7ca84fa3557f770171d23e5acaaa9ec06e3abde84a33d4e2b6eb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8681c03832dfb030664bc1a189fbdab13523601b52c350b4acf501c8fcb209b"
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