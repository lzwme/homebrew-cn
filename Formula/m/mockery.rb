class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.0.2.tar.gz"
  sha256 "64cdd33987aaf091e735afcddbf4fe1bb848ef977c664e27ecde9c015a665602"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b59ab08f6ec529f59bb46d8ca40c2392bb1852bc41efc627fc4ace6a8ef8cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b59ab08f6ec529f59bb46d8ca40c2392bb1852bc41efc627fc4ace6a8ef8cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b59ab08f6ec529f59bb46d8ca40c2392bb1852bc41efc627fc4ace6a8ef8cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "21d98fd062aad88790caa928812f1a265d1a0cd47a5be3d24927622438864a4c"
    sha256 cellar: :any_skip_relocation, ventura:       "21d98fd062aad88790caa928812f1a265d1a0cd47a5be3d24927622438864a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48e142942bda061bfc6eb9eda53a41b3de07b6b9553ce2f36c343448783c53f"
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