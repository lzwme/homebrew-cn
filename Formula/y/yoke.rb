class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.1",
      revision: "7bd3ba0457aebb879be021fa8881de2e511afd9f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89e04efdbd13ea49b3d5bad3dfe40d590f3fef207815e4c996a65211f3291199"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c6aac084348ae00d3482ad823a7cdadac25bafd01505f85361aa990ee74e295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76ff3817162472b2ff7d11f89d43c4bc75520701e3b74ae067d4cade42ecc1c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5878ebfb89da104a134d525466364c564ab62dcf9d15e4f4897417a1287d3b91"
    sha256 cellar: :any,                 x86_64_linux:      "3a8ec477042f95da1f35415490f7c08e6d93c50416e34414488692bff577d3ad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end