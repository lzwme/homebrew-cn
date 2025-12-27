class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7a6f1a99626cd4471353d6726e48980911763dfce67a04131235ca586e75b579"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea8c2d3304c7b5f91280b05c4fc2c1e3941a1591b5ad67d6dafa416d020bd8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea8c2d3304c7b5f91280b05c4fc2c1e3941a1591b5ad67d6dafa416d020bd8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea8c2d3304c7b5f91280b05c4fc2c1e3941a1591b5ad67d6dafa416d020bd8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54aa400055804a634fa06354a6c1d95aa9b5c725d2c87cf377de12f7c726680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55991a52219c618eedfc180419607dafc471be9fe9d8d6325633ba3750b5d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e43436f0f6ef7ccb05bded5c4d8ce15ed81ecbd4ec9d2e8fde30e45344a47a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".mockery.yaml").write <<~YAML
      packages:
        github.com/vektra/mockery/v2/pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}/mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end