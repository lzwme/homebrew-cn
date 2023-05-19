class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.5.3",
      revision: "c1a4616f0ad28cb4437beaa72a100df902c74943"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "194cd9898eedbf77d72abe21af8cd838215e04b33d9613a723d648a1f602b5b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9a0796143b4494330eff498e6eae62b7a5ab9749cf80e69707af28d3a76a1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4fef6565251e927313abf2e3e78208d7ce571d1943adeca3ff0df34d70c063"
    sha256 cellar: :any_skip_relocation, ventura:        "2a7e9f16af0839818681822b8f0dffc5f77ea76814b17190a41413c7e6378f29"
    sha256 cellar: :any_skip_relocation, monterey:       "74f15858c1b40488016e3700401b6869b988605ae6658a383af87b7f3866be19"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ed1f227b34b80312be3e02bd538d84e29f95b41c24da535f92fddf306de3dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e3aaf13de4cfb870583bda99516b8a7a6a3d74a00b8dd80a7dffc2e4c4fb7a"
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