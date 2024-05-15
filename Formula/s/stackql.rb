class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.637.tar.gz"
  sha256 "3783dd3db6e3cf365ed477d584c654d03334268d9ee387f6eb29aa38edf5c55a"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ade0d0ab8e6cdd591f59d6536897d39ffc196bc0981fd038a3561a7011a7202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9447eaa745f4cc7e041f3717358785fba6d54ece973a23489853dcd4b5e9b20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca96349e4fc461d42055a7291b961e3a6f2abd53cb723dd5b9be3e47cc9b9b2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "42e8999349fe8093d362ea7073062925dacc864987641fd2a7d533f94a0a6d33"
    sha256 cellar: :any_skip_relocation, ventura:        "d3249cb8ffa52459bb6ec116b180831cbb5eca9281c297616a8ef10f87c6122b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6b3bcdc946c2e596989fb53bbf310934ee5c62e4c325802ad31785bfcd4d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac6719a00ee647bd99ef0c48954378fdcd3317c0b6d672c8cb3a7df5d0c794d"
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