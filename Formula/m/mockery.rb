class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "4587d74a8dcba1fa36b504b0ac4449126e1478c4bed080e308e1e674f3540e46"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e3be6e2f6dbfa82d54e50d72b8b931dbbd608e44f08f72a8163ac4cd0c5441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e3be6e2f6dbfa82d54e50d72b8b931dbbd608e44f08f72a8163ac4cd0c5441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e3be6e2f6dbfa82d54e50d72b8b931dbbd608e44f08f72a8163ac4cd0c5441"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc030f86018e1969a20519171ca2cc972ae89a51c98440a561bdfb3727e6dc0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9aef72bb1d1ffc474926b07f51408020d11c37643fcaff255438bc37b2fb2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110fba50722634e9f7b98b6b0ae79da9335947f90579ea192033efa2770de03e"
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