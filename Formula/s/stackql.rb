class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.6.95.tar.gz"
  sha256 "c71246f9949313a33a4fc3e920d67e777bef5d4013b2a49170340026eefd6457"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881656601548759e8fd8473e61553c6d2db7800869872f89c62a6477d036c214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd68ca344dcd46c7bc89b7556c795de0ffe0579406d808283b6ba2aa7a78966"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09ff548d6664b40687263bbd1b8b53e76ba4f0825b3254c85cbdca83093c2edf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71246339cad994fa1ac35fc0b884bfe9a702dee48c26bba8570bf62cab39e4b"
    sha256 cellar: :any_skip_relocation, ventura:       "7892a38ea33068625a33302d2574243e0fb206a9210823f4f8c413266edc8f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a70ae6bd46bc90062cb6de7f74b841c59de8cc8339223f5a96d6d13db64fb1d"
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
    tags = %w[
      json1
      sqleanall
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end