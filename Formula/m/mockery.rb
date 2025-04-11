class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.0.0.tar.gz"
  sha256 "472380b8d1b0838274e3e3f8f11008504840aa08ffe61ce3184804d29f111b29"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96555a9134b78e225396167864c76eaa1e522d8f358b6fe017bc93b2d757d860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96555a9134b78e225396167864c76eaa1e522d8f358b6fe017bc93b2d757d860"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96555a9134b78e225396167864c76eaa1e522d8f358b6fe017bc93b2d757d860"
    sha256 cellar: :any_skip_relocation, sonoma:        "f80887d35cfd0e40404686b00983c45d3b36160f57a210ae5a3983257ba8652e"
    sha256 cellar: :any_skip_relocation, ventura:       "f80887d35cfd0e40404686b00983c45d3b36160f57a210ae5a3983257ba8652e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de54e3f9f31411deecab713337f24471c084e51646e22b7f71c31ae7a4be5019"
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