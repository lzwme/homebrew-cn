class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv3.2.1.tar.gz"
  sha256 "010a0c884a93d355f421a0135b2f2c46a0acfed8433ac1dc631aa4d8390c6f3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7b6180b9e051549c7fa180e577ace55f152c85b1764c4c58e348d772d10061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b7b6180b9e051549c7fa180e577ace55f152c85b1764c4c58e348d772d10061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b7b6180b9e051549c7fa180e577ace55f152c85b1764c4c58e348d772d10061"
    sha256 cellar: :any_skip_relocation, sonoma:        "75346ddd92efe61354182d201735936f36ff61e8a7e76681068f126c170a7202"
    sha256 cellar: :any_skip_relocation, ventura:       "75346ddd92efe61354182d201735936f36ff61e8a7e76681068f126c170a7202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62814a9148e192c3f282bbbef73751377b25a41942a73a743595ab4f86392b7"
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