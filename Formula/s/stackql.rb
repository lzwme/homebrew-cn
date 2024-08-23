class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackqlarchiverefstagsv0.5.724.tar.gz"
  sha256 "9018d10e0a95e9fd8fc6f683048511a564f295eda25661578aab5bb93f925e07"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbe94645b8964a90938071b16b9e28b450d080c75e776981323669446e04bd8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "371562462d8b370890de897c1f42fbb7ef8f96ba99c974e5952139a5b01a5f6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7020b74186a407288f83f36575e8d37626ed3132e70a95e6abd8e15db2f92cc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "11cd41737558f7866d730714cdaf08b28d233a9d00f16836fdf571c091118e9a"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a91a3b20f797dbd44b1861616caf16516d74da392b4509b302ab1eeeb2a521"
    sha256 cellar: :any_skip_relocation, monterey:       "1160e14b26c92beebdfb1c5396ccc3ba24e96eb99bba4aaf603a5defbd836e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9af8dcb7c0dff9774e7f80dd2baafa4f2c54e08e5588e3d9279152ef277a2e"
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