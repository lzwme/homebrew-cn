class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.12.1",
      revision: "961b24fe6b2853325b8231c04f4014121777e5fe"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6744ff482d08b8ccbb8b66a674189cf9247ceeec3f968632d0bf6251280d3e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16c4f1bb68c97117e357249c06c5396f74e3ff081bf2259e7d0b31c12d018eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10105a57063cdc5212f0521d5534900287d5f6d4898e733ce96225f7b13dcebd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a94ced5080791f319d5a25c5db3a17bfd026f6d3b32c4c6d354c51c06eead4e4"
    sha256 cellar: :any_skip_relocation, ventura:        "eac210193b1e5e151788455326d2f0e2eb1dafc4d4c547b5787c5279243d925c"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7aeecbdb64a5248fbae28bc846c0f3938e74488adda7baa20a698cd3127195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab598182406772a07811bb3550d929987bdfaafc6300e6fc304d5787cba7061"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end