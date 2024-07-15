class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.692.tar.gz"
  sha256 "11749d2a5360f902c68470f6b19f05019ed239d464d5ab9d9a9453eab66ab91f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cb4595818e4014a80ee762e480da6f276ac5627879d6f5065739f432fccae1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df5471bf953a51b70005d85d69f8145145c0982f3884a79d065ce51f8c7cc81c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e27db09a0183f79220e76896d0f67f5ca1bdf631139b77e715b213d9a30a64f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7452970e8a5ecb28a3782a389f5e7b75cd35b785eb53d35ec537be8126ef1987"
    sha256 cellar: :any_skip_relocation, ventura:        "1ed541ce090847123a8c4042682e3629dd466eb8f5245b307bb76ac25117063c"
    sha256 cellar: :any_skip_relocation, monterey:       "a228e99abf6b7eddc9ad2f007432e2cdfbaa004d796ee81b863373db89d29bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129930ead2d43b1a11d152a3912a998fbf22bde922cf52f0b741715adc118db0"
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