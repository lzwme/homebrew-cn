class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.4",
      revision: "05d7b993fbaa5c5baf420304add47251660bfeae"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1911e7871fb9c91a6ca891f55c6cc34ad47b11887bbc6e204c6ff55dc5bb30dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c56abba2f460b09276f893277c2ae00c68c5a35d0b2dfb55c2ac42aad6e6cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9efa03935101572b6a5c49069aa118343abb2e6a3d4f025c4b2ee2ce413ce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bd2255fe2f7b53697a07674f752cab2803ba550e07e6d0e4c362b3c09a3db0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f52c4a21a60282a5316efbacd54a81be64770e4aec744a8a95d240cc2123658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fec7b19b000105335a01a601ea419df00243aa23cdbc885cd555817432c065e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end