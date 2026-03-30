class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.9",
      revision: "a3cbe4c9732effa9435b79d0e12803f7f3f421d0"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c854db98bea80aaef8f305ea363528981b15230642bd917f2ed46c4e4af97e9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebddda42b5bc9dee1277dda53546af56c38c1a95c0a14dadbb6f3a098115f814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c44d83e9824a8fc4567ad41cc78b0a05d62b6214c1a01c9d1f2f0c407761ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "681a8ec791b04fcda61499b41fe9da9699b0ceace5d2c38a4b60f6afa54e93f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ff276f43dad3d8040e4e4d0f667e3502b7c349010949dce2882d9cbdab590e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd914179f4499f751884404738025055466ab5d56f3d901a19bded5310319adc"
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