class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "7896538b619a77b97da53a6a17195fbf652ef1b02e3673ad787a39a2aaf91f05"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "521167c7b23fe4951b1f9b14005c104f6f9cf002ed53c791bb96e5e09b612641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521167c7b23fe4951b1f9b14005c104f6f9cf002ed53c791bb96e5e09b612641"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "521167c7b23fe4951b1f9b14005c104f6f9cf002ed53c791bb96e5e09b612641"
    sha256 cellar: :any_skip_relocation, sonoma:        "44305805425e39b57c6387ae1448d7484529729df77d78dde36534e9201c5235"
    sha256 cellar: :any_skip_relocation, ventura:       "44305805425e39b57c6387ae1448d7484529729df77d78dde36534e9201c5235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da090d499873cb699bf64b978abf128238962cf891017c218049bb99b85708c"
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