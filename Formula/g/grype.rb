class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.93.0.tar.gz"
  sha256 "b2fafd110cff50ef93902d95058ba688804aa971a2af5616fe1c46b17b34c978"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ef7cf3c0affffa7a314739ae29bdb643dc82dbe29455f2d3552b0e49bcf776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baefe597b2df1b99028cf77aa2159034ab8b8e4bb610b833cd61bb8c4c4cdab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f7d85dd1294ea04c4c3cdef5d0d3eb940cd79ec57adaee3e12a0697ec955f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f9552fe853fdc519671ddb5ab796b309994a9866e55f513b02c22b363c98d54"
    sha256 cellar: :any_skip_relocation, ventura:       "c3bf911494d7950c38c8cf10cb0d7d5e67a11d8f58fda198a0f288e6b888106f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284a8a34c4c654acec7435fe589675f1621173bfe8f6592368e589c5de88ce05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8876aac40add928abec4392a3d4f8494c9d91e7390d5a9018f829b1692965cb5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end