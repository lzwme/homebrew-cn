class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghfast.top/https://github.com/vektra/mockery/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "98c58a9ab36aa6d76351ede906756a06dc1051c889fe0f7d2ba60a7216322f06"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61aee71ffcd1e5d0ad722e6165c84c78dffd8e37d9e102a6fec8fd77f661cba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61aee71ffcd1e5d0ad722e6165c84c78dffd8e37d9e102a6fec8fd77f661cba1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61aee71ffcd1e5d0ad722e6165c84c78dffd8e37d9e102a6fec8fd77f661cba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f29bcd3900b7fc317ecec36e8e3356aa122d3f817252b87bf4e7e9970fc2e6"
    sha256 cellar: :any_skip_relocation, ventura:       "58f29bcd3900b7fc317ecec36e8e3356aa122d3f817252b87bf4e7e9970fc2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17937932daea8148fe02d1eb8fe13426108d2c2fe975d3cfb9bf3eb66256c52d"
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