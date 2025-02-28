class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.52.4.tar.gz"
  sha256 "5c70662ff3281e5b4d899ded586d997b88dc6ef9e73488e69df955cbd39d57a4"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b05ad36ed8d38b51423fcf7f0bc98f93ce2620ab50543a63ef24caf447ae5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74b05ad36ed8d38b51423fcf7f0bc98f93ce2620ab50543a63ef24caf447ae5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74b05ad36ed8d38b51423fcf7f0bc98f93ce2620ab50543a63ef24caf447ae5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e595b1a5091741139df14466838f92cb22ead27db9c702f5dd1e8889b985678"
    sha256 cellar: :any_skip_relocation, ventura:       "9e595b1a5091741139df14466838f92cb22ead27db9c702f5dd1e8889b985678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1916bee23c6379c2058379a6a6ba2aad0a80f85bced16b03631c7478e740f50"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end