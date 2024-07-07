class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.688.tar.gz"
  sha256 "3d666406cb81f0658405681e29b32ff8c8469e74166d4b4dd6f8f2137f31390f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41892f93ee1f1c2eed172d81842a880462094d732882a9d7755b8fb6c1c38af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235c1cf2dd892ca497081d6548ad247fe4998e9b3c64a21a26c1af638c3d2211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0451c2eac0fe6d67e5d265e9ddff13d9fa43e5bd4969e95d04521c8ecc39253d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c054a837fb23fcc8db943585ec1b97a45d9a4d0b3d493a2041f78f8d4564caa7"
    sha256 cellar: :any_skip_relocation, ventura:        "4417081c027f12aaa1925e53bbe01b093bbadaf418f67ee9afbc4555549dca80"
    sha256 cellar: :any_skip_relocation, monterey:       "a67576bf0ed5e60cb755dc542665c3f703b23455cd437da7795d8f2dc2fbfc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09cad2ceae5da271a5f1d9ab6ee9060670b0301393735053f4da5ee74318c89"
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