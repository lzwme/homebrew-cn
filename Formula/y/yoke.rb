class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.3",
      revision: "746f13ef7c3be29403d9fff3b6d523c3351161e4"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d2fccb3c7a214c1b7c00fcee9fd7879fbb0c533d76c04024af0bbae98622880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fa3b93dde9258cab71fef56ba9846ff70924c3fe06813b228c4499b43afcf28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9417c3a5704efeb3e946ba1c1c3b5c747744b24ae45b819de983f01183c3b9a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcec091a8de86d4e04801e5036097cc472f3c686285c1864a0ba4d0f4363ba91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1731223bbcac4d9453a224458a4abc3c1bee62e086a86e4ea7c6f47ffcf8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ea841dc72f1ff1ac206e0c41d7ba276d8804f82454ab64d805a4a6ad3d8d18"
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