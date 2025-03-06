class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.2",
      revision: "a4a5df40d0183d76362826ef084294d924c8c959"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e796914c6ceed01ef4a181bac5eea271b79cda1aa7a0b09f7fd06b37b0bdc93a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e796914c6ceed01ef4a181bac5eea271b79cda1aa7a0b09f7fd06b37b0bdc93a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e796914c6ceed01ef4a181bac5eea271b79cda1aa7a0b09f7fd06b37b0bdc93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9697fc94ce462e5d7fb9214b5ba92186a9bf6a1bcea754a12167eba5c506181"
    sha256 cellar: :any_skip_relocation, ventura:       "f9697fc94ce462e5d7fb9214b5ba92186a9bf6a1bcea754a12167eba5c506181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb4ae5e8d37531487d01738171da5c62b3fec9665b665f62901aa316b8c6727"
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