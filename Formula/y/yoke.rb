class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.0",
      revision: "c395f1004936a457b954017a2518070cb30e94a8"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "727d9063109a662a63da776095c0f78533ae81de1303fc56f794726bc6e8c82f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727d9063109a662a63da776095c0f78533ae81de1303fc56f794726bc6e8c82f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "727d9063109a662a63da776095c0f78533ae81de1303fc56f794726bc6e8c82f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6be6f211abfdf91de6737831dcdfa37e450dc736f34a20a09ea4e8af17771197"
    sha256 cellar: :any_skip_relocation, ventura:       "6be6f211abfdf91de6737831dcdfa37e450dc736f34a20a09ea4e8af17771197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed15f918742ab657ce3842dad28114ab6d0f7c506de42747fa00aea97a23462c"
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