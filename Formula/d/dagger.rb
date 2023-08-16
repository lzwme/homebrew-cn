class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.2",
      revision: "dd21d293ca4da68998d15e6ddba91f42d8050520"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70639e21a27574f5008133f7f3f0a742431f5819c2d38bafa78f64121f2c98a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70639e21a27574f5008133f7f3f0a742431f5819c2d38bafa78f64121f2c98a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70639e21a27574f5008133f7f3f0a742431f5819c2d38bafa78f64121f2c98a0"
    sha256 cellar: :any_skip_relocation, ventura:        "87f242555b149907b2f257997f1f616f0d4735e5e6871fe89c23ff1e15290266"
    sha256 cellar: :any_skip_relocation, monterey:       "87f242555b149907b2f257997f1f616f0d4735e5e6871fe89c23ff1e15290266"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f242555b149907b2f257997f1f616f0d4735e5e6871fe89c23ff1e15290266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9585c0a44907e5b051b7a6973c082494c19a07c36468a5e4a30cb44786249203"
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