class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https:stackql.io"
  url "https:github.comstackqlstackql.git",
      tag:      "v0.5.571",
      revision: "10b7ca269eb702951d0edf9837849a27785314f4"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3a992bbc6605141d359f473af6d998151510543c6bae84b3b2084cbeef3cc20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9a774e512116cb49cf858bda189ffe13dafdcd8d3dbdd5af6c69860c820dbe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1d8f2eca0ab88dd2ce791c3ffb3bf7d5bde7b2456b84793cc87d1e0ee5efaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a55531a3cf05552f54c222632756f6c291ccf9aa5d935203976497246c7d6213"
    sha256 cellar: :any_skip_relocation, ventura:        "7b593c16f9aa692bd493afb5ca9eaae306366f303c7c7d9b7a6aaf2be0de40b1"
    sha256 cellar: :any_skip_relocation, monterey:       "93d4b41c6564484a2a0d652b8b6ade0bbee536dd67cc6929e115ec9dd0283c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77a6441f5f2d3d6e024cd0388ae82079adf25d816c72c03961365b46da185d4c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildMajorVersion=#{version.major}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildMinorVersion=#{version.minor}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildPatchVersion=#{version.patch}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.comstackqlstackqlinternalstackqlcmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackqlinternalstackqlplanbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", ".stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}stackql --version")
    assert_includes shell_output("#{bin}stackql exec 'show providers;'"), "name"
  end
end