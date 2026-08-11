class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.26",
      revision: "b5645422abd93d43890d015f9d4ded37206a3ec2"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26b90a503fc5ac4e40996e1935b83f634598b72f3f2b1d7103397e23d45376a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e11a2f8fa6011746ab3e026e862dfd305e1c3bc6ca34bbb1b82218e0921a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c31639dadb0092d66c9b90de32edeaef5758636cf0a7e4e386afe04bb0771dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "280ed21aa1f0b0f96d3ddd6a25bbe71ce828f69d023fb37fa8425f29d40f58b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe48b15ebf2d3f671cb376009ac0d09b62c26d6067cc65b8adc849c46cba96f"
    sha256 cellar: :any,                 x86_64_linux:  "6aebeb3494a23eeafb77305c23b3405fd1297aca0d6fc6cae66ec38971d0165f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end