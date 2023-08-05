class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.1",
      revision: "2b855693b080a996bd0be19826754984684dd145"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5270873e51eafffbb9eb11b52cdef5cb77461fa81cedd519a0ef61e5f12bb864"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5270873e51eafffbb9eb11b52cdef5cb77461fa81cedd519a0ef61e5f12bb864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5270873e51eafffbb9eb11b52cdef5cb77461fa81cedd519a0ef61e5f12bb864"
    sha256 cellar: :any_skip_relocation, ventura:        "7ead28a202498b7e9496a15a621ef03df3be54d0ebf7db5bf0f12b8ac04a6dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7ead28a202498b7e9496a15a621ef03df3be54d0ebf7db5bf0f12b8ac04a6dd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ead28a202498b7e9496a15a621ef03df3be54d0ebf7db5bf0f12b8ac04a6dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0adfddecaa6099834fa0c44afa6e56e831b68ef2f40874b9dc8eccc04b525f4"
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