class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "117ae4f51d1c6699dfd5bf404ffcc1078daec50dd637a1a7aea55c3ed8f30fa4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b693ca08debc2598ec299a9d9df4c572e0a1c37fd76e23c63bd4eefbac2ce4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b693ca08debc2598ec299a9d9df4c572e0a1c37fd76e23c63bd4eefbac2ce4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b693ca08debc2598ec299a9d9df4c572e0a1c37fd76e23c63bd4eefbac2ce4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec528d364ecee0089ddcfeb15ca03030313f898f73c574e4dad715fea2dcd271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23bcf76573cbc4f565fbc6c58dd9012fd1565ffe9ac14cdcdd327c59c4de51d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4079886237d9fbd10a915c1964064d8fc5483a117f76af227f886683e572d3d9"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end