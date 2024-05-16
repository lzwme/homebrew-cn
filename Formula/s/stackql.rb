class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.643.tar.gz"
  sha256 "21a93d107772c0592d1e4cf1239ad90802d2ae91787f3027fd1ec835a490eb15"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "499af67411c8f7bcc5fd22d484925338fd5601579bd643030390e30290ef1616"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d83f19927314b9fe3ca1651447a3b65c9836dc9c843125253f6ec55f1969421c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a77818f875afa509cfa9d592fc938c1eac26d4ec31d49e1d2aa762d4426b83"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b0e1a18b2c3ee69bdb7de74d9c3f4d8060350c5fa060146df5a2f3e109d2714"
    sha256 cellar: :any_skip_relocation, ventura:        "a3fb65eecdbd6d730d6109cf49868ba8c8d6cc3729a33f100fc3e217f61b4f23"
    sha256 cellar: :any_skip_relocation, monterey:       "e489a0bae5cb623b1975b59cf315022c5f95af2c5fdebe6bab050ab0176eeae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4953777c19e9e4599d7d3833ac8c6349c8861ef9fe41669e6686a82d7642e6e7"
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