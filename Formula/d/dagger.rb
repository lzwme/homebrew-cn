class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.5",
      revision: "65c2b63d0ddb959ee97fcd0020b18e73fd9409a1"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4556f73da314d49c57f96435a0ee47f6d72daa827976d9a2e9655c9f22a4e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7628c19339b9363322067aa06fe809117fe5467392cbcb59bad520bbfc55d573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3905a24a5cbd2d9cfcbb206b970d223651bd964fa5f0854e2f8c207ee6cf543"
    sha256 cellar: :any_skip_relocation, ventura:        "60ed59cca95d8be48250c418f8f036d843dd876915eacb47316ec4949267060f"
    sha256 cellar: :any_skip_relocation, monterey:       "3c84b17e5047c1aca173a54b53902379fd48a6c5d6c1d523f1f3253421af086b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad8db227032b55b15a91487dbdb0f1c2465d9c152945974d13a87207c595afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55dd01cd2bd2415b38fb0d1f4e58582928f04df2b658a05dd852827a402d3f44"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end