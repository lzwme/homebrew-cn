class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.18.17.tar.gz"
  sha256 "e277e4d2b8f5915099c7963e20ceaac9a0a1de6301a36affa2a545cc326e576f"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e387ede20f716190e15f4a74384c74dd639a8e529cbd9115ab3d391a55b192c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e387ede20f716190e15f4a74384c74dd639a8e529cbd9115ab3d391a55b192c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e387ede20f716190e15f4a74384c74dd639a8e529cbd9115ab3d391a55b192c"
    sha256 cellar: :any_skip_relocation, sonoma:        "79fef65119064cc93d82a220304e516abb2b5b135fa65ca93ecb8f8f282c3526"
    sha256 cellar: :any_skip_relocation, ventura:       "f53c5cac286d5fd0d8a214f3925c91b36c3001cb48c83645a1a5476008cddaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96fe5ddfec92a81fb349a9e0c055e582b22d74f7ef0637db00c509f4bf478006"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
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