class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "6071a0d2f8f9f3749a8de5d5f856aa903607826794865581d2c453b6fd2aa3ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a39c96a776db7513e64735a9e14d016e0828711edd3bd8c141c2cd7df4ed478e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a39c96a776db7513e64735a9e14d016e0828711edd3bd8c141c2cd7df4ed478e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a39c96a776db7513e64735a9e14d016e0828711edd3bd8c141c2cd7df4ed478e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9129fe03ca0b084b40dc82eda8804723c2ab5c898ba6526dbe50ad92298333"
    sha256 cellar: :any_skip_relocation, ventura:       "be9129fe03ca0b084b40dc82eda8804723c2ab5c898ba6526dbe50ad92298333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a695276bafec0828bef576549e771e751dced096e8e9e43be548ac0e01d261"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v#{version.major}/internal/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
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