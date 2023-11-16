class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://ghproxy.com/https://github.com/stern/stern/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "ae87a657544808e35fe7f3dcdb6f2c8b2c86845cf76c6ebb1058bb9154f0799f"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97fcc24d4338a843f5330cdc7f75c1a438ec07418995df137487c2d6d2831569"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0108aa6ea6ba4f0270f09e53c17819ce4842c620d0b73715eabb2f692bca0b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf33bda1fa1449f2cb684658bc9065af1c7a95332e51d5818ed2e950f050083"
    sha256 cellar: :any_skip_relocation, sonoma:         "08325f407752b92879642606b79ddbeb7df4a2a2c796c70f77ea78859dc45fef"
    sha256 cellar: :any_skip_relocation, ventura:        "da4679eb2a33d95af54c03e03ad8f51f611b25ff3d93f5b875adb8d3e2342acd"
    sha256 cellar: :any_skip_relocation, monterey:       "b84c26af79f0c696b071da38b17a885b8eb15a678795874a6436839320c071b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa1beac122af43961abb80fa42dde199298d6ee5261d1b9a8e6fb5d81927434"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end