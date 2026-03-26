class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.30.5.tar.gz"
  sha256 "24f7b57393d4caa01436d5555f96124c1d2f96c52456f97ef3bc8861fdade0b4"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9056c917f8895a8b1f029e18ac69545ebf264276ab521356967fc2d7f96c3589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d788da4aac9816da120e418baab269756b6f08ae41a707da27a3a5a5d4651187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a8df2959814ef1d63791c1fb7568051af4c2bd2107b166cce87599bb9c7d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "84910af5880d0d4c8c05fb643e782515aa242950f6532a9c5062c6d953a47837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e7aeeaa274eebfd7cd7d4a0bb04ae77eca1d6d2f3dc19d4ffc7ed8d96d809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95997050af83aeaaea9b8d491a7f8cdc46464a6f8bebcf0942d3816df384adae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end