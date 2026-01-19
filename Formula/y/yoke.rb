class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.6",
      revision: "b5c7bff475e6596843272aa7a4255c8c5608a987"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea5fbffafc4f5d78ee02875f2a06b14e3db568c604115c169f93eb6f6ba9b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f08b20f0413771265f760c3911b358e2ca9191687d70cfddfce78a763458fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5d058a4980e99c55be6dacddcb2dae6f8ef37e210b6ebb37c6ce5ef2c21b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a979d3a02065a2811d773a4166d299fad9e01c6299cc1f1398e7b63a93ada9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096676d28c847af42424d5ffa317f106c6313e3fb2024eeae782792dd23f24de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eedda1008f8e0927317a2178694985348d9cc4cf158d0efc4aee7b1cae53aae4"
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