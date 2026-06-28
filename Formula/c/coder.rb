class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.33.10.tar.gz"
  sha256 "0bfa8a64fc0603985c37b8c4e501934b9b80041a8af45fc09f86671837d37506"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0413a8be95689dec168d9e5cc699698508efbe4074781d60b4e595700fc0e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cfca173f69907ae1cf055e3475b0f55e291d5d75c8d211c61a0a6c7b004f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05c191691818d8993f0cff2eb4f061de12770e8e51faff7c72a0b2f8a7f46e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0079dc5272986508f19b16a50360970ac83d26d75afee839a6482f2c9391cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7509274eccb78979914f4009d39a340d234fd9fa22a4fb3fa2c1552a053e49a6"
    sha256 cellar: :any,                 x86_64_linux:  "b7ed72a4ceafbcef1cb49c8f048268e8f0e0608a1f682528e6f216c769848fd0"
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