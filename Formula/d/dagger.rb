class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.0",
      revision: "f58b8e798395a9450298dab64f95beee2269d930"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edc799a6fb4e0d1d9d08a1f3f7a94159656828ce7e2dcef3f34819d57f848acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a36c46104c9f8a0efb5465551fd0f6ff6fbbb6da886028cb1692ca17ef8d999b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0fe8ec96bdcbdb934093fe75d1ae3240c3bbd2761d30e975f7bde898acd6d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaec2424407013bd0dbe162a92bb1b8090d54d9860bbfce70ba6eccf33a35ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a5df4c3f52129f2c0541956d7d3c6af1a6e726b93774bb2236632672654558"
    sha256 cellar: :any_skip_relocation, monterey:       "9a12b711c54f30a61a8191336c274f51a8efb2475a47b8c47449a139f9429000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6ba8a034484502d4eeb85f42feac2285950faabc7155fd42d7688ff41404b6"
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