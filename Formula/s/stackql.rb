class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.6.7.tar.gz"
  sha256 "62569781d806771b5fc118d48fc09dd7e4701556481c2001e2207bed6e929713"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb3e676b8da95fbd01c44ad0dc8abc0e9ab4fbd3dcdc8f2fdba688ed1d279f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ed0db58fb9917328b881117e21b0dbf59a38a01b0dab6738356fae494500ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96366f122afa1218b2a2df7103963feffd0ef850163b7717aaad0bc9cacc688a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa6796f15c82f8ac35b2f964f3e0aa8573a2940b8f5e5e76da09ef5e34781599"
    sha256 cellar: :any_skip_relocation, ventura:       "b9f033b542444ab2222bd7358b45ee9333c518c48d40c7ad7d4aceb10d6315cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c62168986e4b37a430ead1c7485e4b028f0a24cf7245d99a2677be653927c7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMajorVersion=#{version.major}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildMinorVersion=#{version.minor}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildPatchVersion=#{version.patch}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildShortCommitSHA=#{tap.user}
      -X github.comstackqlstackqlinternalstackqlcmd.BuildDate=#{time.iso8601}
      -X stackqlinternalstackqlplanbuilder.PlanCacheEnabled=true
    ]

    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end