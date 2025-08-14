class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "62e442cc39c54dd0e38a093c9d4571e2b3ae9980a62908d065ed730480ac3f1a"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9699e0acd9805a6893e52805c801f4bfb80f0c881030f354007ab3319dc23035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1cd66d1f7cad1874e0e2280590821998902f0ea50b167bce0bf3f8fe8e25905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14f2dda2a43df3a05050464605df2cc876c67ac6ef84e9b68db173dc59dfac10"
    sha256 cellar: :any_skip_relocation, sonoma:        "5058dbbaa3195622996689f9eee2a5658e58cc13aa96c047f660ab6f8a38e457"
    sha256 cellar: :any_skip_relocation, ventura:       "71c31f60cb4a6a71e38c0bf6ffd4ca083e25b1d16cd9a778bdf90ad029b5071a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74c034100df5286fdee0fdd7e0b25a584cc061a1d1d2815d570052263fabc02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6eb52446752af07c303596c3a93e29d4a10bbf88b1c23247130353d790ebd88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end