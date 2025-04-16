class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.2.2.tar.gz"
  sha256 "0f42dd7cd9801605da9b43b7c9d5132e6f3854249c22754ea44862421b28187f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ec81809a1c1ab5a55f4168ea3b9775764d2aa8bd9d3744d22c0c01bcc251cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ec81809a1c1ab5a55f4168ea3b9775764d2aa8bd9d3744d22c0c01bcc251cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7ec81809a1c1ab5a55f4168ea3b9775764d2aa8bd9d3744d22c0c01bcc251cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "505321cab8105a757978db86de3a7d05953d25a626ec54151d911eed2be5f924"
    sha256 cellar: :any_skip_relocation, ventura:       "505321cab8105a757978db86de3a7d05953d25a626ec54151d911eed2be5f924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6d1dcaf8ae35a678af85c925b18764e616d0dc6d0d0df23193fc77544f4d3f"
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