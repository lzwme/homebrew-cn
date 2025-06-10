class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.3.4.tar.gz"
  sha256 "74ff554370bafc230f923ca5a778de61704641d0b56cad9bfd69791ab7668757"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5421d251216dad9eae68df6de6745dfbce108a50b0e33739226eded3d71386bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5421d251216dad9eae68df6de6745dfbce108a50b0e33739226eded3d71386bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5421d251216dad9eae68df6de6745dfbce108a50b0e33739226eded3d71386bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddcb82a47c03bf2b39270abdbc8d13ba7108c4626383b371a2149dc3f1a52244"
    sha256 cellar: :any_skip_relocation, ventura:       "ddcb82a47c03bf2b39270abdbc8d13ba7108c4626383b371a2149dc3f1a52244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c701845bc88eefe27d13a83d88a13384301f105c13cb1e8dadf50115fa44d4e"
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