class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.2",
      revision: "ead34642fb2eb3f26516aeb7fe1a384dd85388b7"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9c955bc8484c1ba6f7cf3fa55ba85a62ed33d20bff5f9510fd8b1bafaaea4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2830709cbb02bc8221ca53af1268e83e553cc2d707d28d7cdef7845d4157a9a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4594e4def45a76499a9a589ff8b88591813dfd4c847a43b04229799b278048"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2783a3c465bc1f7b2f7193c3d00f8df62dd5c08df4ee36dfd0cbeda972d9897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16aa5119ccc763ba4d5ddae94201094a506800e299e861a7d574a743990dec2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c98776bd59df491710a82c7278fa910b526b6c3220712e1e1ebe0e01f03ce1"
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