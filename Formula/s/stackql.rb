class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.740.tar.gz"
  sha256 "92d042037a2024f35164fab9a4abff9fb29eda6c3a6e9c12790a5c605142f74b"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3484e921a6a039a70c735861c92f8e5067356ac196cd76a5256f50eec263f69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f7cd63bf8afd06487056490d7d6fe0f9447590526ce3dc9baa83db3874e00e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14845febd67ad8cedba4cd96875d498952bd8018f3017416da77218a12f10d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b9967c9e0b858484daccd082c5c0ad38bbd681f5b889ae3727e5151df5f72db"
    sha256 cellar: :any_skip_relocation, ventura:       "58b539f614581ada56394e14624c0fd033ee42895f46c73e0d0d497b9eb3b15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0849f4329deb51c81255a451b2e8e23905af3e39585b8028e97282b9198e8e57"
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