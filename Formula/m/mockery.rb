class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.3.6.tar.gz"
  sha256 "603a4b2dd859a275f50feddf08cb4f4f18304f67577476893dd75f28497c1ff0"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "v3"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824608f8740f372031e31d431e4c875b9993da90fcbeef10d26e02e5aa1cbcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824608f8740f372031e31d431e4c875b9993da90fcbeef10d26e02e5aa1cbcc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "824608f8740f372031e31d431e4c875b9993da90fcbeef10d26e02e5aa1cbcc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d396c8e5772b3844f8855f704b7ea988745a771b67bdf3ab41216c7a5350454"
    sha256 cellar: :any_skip_relocation, ventura:       "6d396c8e5772b3844f8855f704b7ea988745a771b67bdf3ab41216c7a5350454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e70261d5baf349b7ce2e8585cecf5fc04d0c86099af5d938451298006faa38"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv#{version.major}internallogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    (testpath".mockery.yaml").write <<~YAML
      packages:
        github.comvektramockeryv2pkg:
          interfaces:
            TypesPackage:
    YAML
    output = shell_output("#{bin}mockery 2>&1", 1)
    assert_match "Starting mockery", output
    assert_match "version=v#{version}", output
  end
end