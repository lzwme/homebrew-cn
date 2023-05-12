class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.5.2",
      revision: "a2d8aa020c6df14949abf69ab47d079a34be5a78"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255518137cdd9a5b0dd5833e55902e57bcd77ef8a338c3a54368b044ae31d982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca1ea0459ae6bac61e286d0a32e4b77fd8aff715d7f98f59995c66a61b724c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2788dddf9aa2304180ce07dd6e1408400038468f782561eddc8ca5edd12da25"
    sha256 cellar: :any_skip_relocation, ventura:        "affa9539fb0e2036cdf1be5eddcf4a3338a3d2b17a18d4ffadcd4675bfa4b7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "73c99395ad91ba40ff17aa5c2e73f020e0d20171b80bdfea172ed7620660f99d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f56f3b677a45ff73bd69b8ee5b86981959911d84f97f2b676ee1c6f6cd2140aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8381ae761ef6d2520b3c3fcbbb76c7dedcc3488a173b8a2ac0f076929a341f84"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/internal/engine.Version=v#{version}
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