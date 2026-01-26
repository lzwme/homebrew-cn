class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.8",
      revision: "488c432b1a7efaf4d69427b0d051ac0af6870657"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c6447d9f9378f60c0b1197443f292ccb1eda07aa40a4e73786f930b8b88fa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "354fb6a7e986d0201a43546dfe51adffa61cf7ce3d68ad7e54765544ad619405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344971a0a004674747756ae5a9e0fe3bf8507d6b9e8941505e4db1c7084f3618"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa86e8031b151b645beb3032d7f99d6ec9a339441fb0b868f76f7aa8c1391d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29cfd4eeaa5121679b910a911cd4f2a1c45d4f9530c20d427274ac3163e783c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e734bb6ad62d74d4fa072b44d38b4eb711da9cd8526bfa3dcb8b0e2c7f7620e7"
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