class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "3b7a7ddf893cc02787248801f9f857141264372e38fb51dfbb5e397732063517"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95b308ed1aa6c9a01e5fce70b6c1e138228c87778bf54b2e58988a93011cfdd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c2af4435ff8e65ce5b71699bf7a78c7f442649e58cc627d7584aca29a941c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57cd198a5136bc96a225528426426c5c2ce761f502ed504ca84067222f95f4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "e44258f1ccf26a998ed8ae808769070fb037e651edc7927e098bd882207b9305"
    sha256 cellar: :any_skip_relocation, monterey:       "40cd6258e2e66156960de3c9b5b17f2657ac8144dce1a376e5d430c7f699c4b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0245f5363f03abed106eb57e55915ba6b1353b7c64f4df4c4e69fc5017c6107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed587a1b4b1b23d8752b45393ec6e5d7494e2cb35d94563a997c656d3748ef3b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end