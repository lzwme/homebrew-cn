class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "197d3d83d4bf3ec5a04b2dec73c26f5403f0970ff7eb089646732b7f5734fbd5"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b111f6ef34053e81ce71587e5a67f1ac53e8c26bbcea5a60789e4cfbc0ad82da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b111f6ef34053e81ce71587e5a67f1ac53e8c26bbcea5a60789e4cfbc0ad82da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b111f6ef34053e81ce71587e5a67f1ac53e8c26bbcea5a60789e4cfbc0ad82da"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d500d7b9be0f094bf5ec28f460165e885cc81738d8041e8d5e710d42f729aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2433211cab110c31a1da16782c7e18018f37e7067b375cebcca3bc82a7c464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19e3f73672d3bbe3558b9a43da2dfe616e1f9f749b6120fbf6e48d042acbb6c"
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