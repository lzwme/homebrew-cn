class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.5",
      revision: "5645e381040e3ed4de559baccc64892ce3772671"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65c0f5e52d2e2fa16ce19e19777a098186a8aa15c579c5b163ecae5d093272f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b2bf2bed6b37465ba5d57a571c77b741d60995e5f0816a851da02db1cdd852"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdbd47ca0cfbd505cec1dc2f3f9d6d7118d2f1bf99c659a3372fc5adc657559d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd64dd1113218bdc53ffc05609dba4139ca5fc7993c9ed7e1b49e83b19f2a4f0"
    sha256 cellar: :any_skip_relocation, ventura:       "84bbf0a7090aa276a4dcdec68ef7c45ce2be6009bb53949e0fecb3394141f8cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c2a2ccea6be8d0deff870110b4caa5c277eb94959003df2fcc2c7cb3119088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1451933ada410641639aed3b951371a204e3b9933fc5a42ee25e200da7d02e50"
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