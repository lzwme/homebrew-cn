class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.40.3.tar.gz"
  sha256 "cde329afd49edde411127ba65f91de68b0eebb359d968024990d1d6c9b0d19a3"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac04ab75360ac019310b8512e7a008ec8af8eb148bc73ee4e403a6c1b62de379"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ebbb6159d85640a40bf466be782f8c2754386ea2b05dca6792c1f8c04092fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01460081d3b147048b43571a39d1b046547beac8b94046f8bd8b4ffc8b468499"
    sha256 cellar: :any_skip_relocation, sonoma:         "674c16e126cfb265811867013ff0a56adac1f975f3745f1f7f94d9effcc857df"
    sha256 cellar: :any_skip_relocation, ventura:        "40785067f599626766c20c1908fbf1b24e0de5ea8ce5c1fb4e655d1531bc6d47"
    sha256 cellar: :any_skip_relocation, monterey:       "c10976234faf4103cd842295dcd0c1de35e1f7b50bf8ae05fcff5fb668e9d1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9925cce100bbcbc2b8ccb964c4d0708cec4eeca9f7bc7ed1b441e549edbdaac"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end