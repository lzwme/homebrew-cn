class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.101.1.tar.gz"
  sha256 "d5bf014728f975b0a281d797aa12a18103013730a5fe95e66eae499c05d2bc42"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "032f5dfebd957d2bc42a77a90894af3c5b33036f2ce82a8c974766c5f5d123d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e6917c168272234c3e8c26b45785e2cb51d958835eb3457409abd8b6107318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74278d02d7fbba746fe73b9def700dd0ded7c120a478bda50577bead8ed7bd97"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4dfd3cc9224d7f8d36c70ee83c5790e5ab90d0afcc48915f3d72504b88da94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16241a54deed4f14d15a3cd729fcfac660e95ce1cd501537faaa5827eda01367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a4ed8fa9b30b1a5582da40fbd622f62aee54f4342c3ca48c86306b5d17c4abf"
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