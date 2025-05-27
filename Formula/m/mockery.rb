class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.3.0.tar.gz"
  sha256 "d483fc30b265982b7301b42053153c706577217e0d8354874552d1fc49304d97"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151eb91d47a460d903efa1930ca4385248eeb146b5e81216a9e2c2399341b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151eb91d47a460d903efa1930ca4385248eeb146b5e81216a9e2c2399341b8b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "151eb91d47a460d903efa1930ca4385248eeb146b5e81216a9e2c2399341b8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fbe1f72e5c7dfcfb7dea8935ce9d045c4f74be1d32ab3b23696eaf76a660347"
    sha256 cellar: :any_skip_relocation, ventura:       "2fbe1f72e5c7dfcfb7dea8935ce9d045c4f74be1d32ab3b23696eaf76a660347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c54d090202d88ef521faaa3eab50680dadd89a80472f471838192aac1d96b5d"
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