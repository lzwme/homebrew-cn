class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https:gruntwork.io"
  url "https:github.comgruntwork-iocloud-nukearchiverefstagsv0.38.0.tar.gz"
  sha256 "71a773241c597fc4d8d572a193afeddb27624fc0a6c38e330f84551fe252bfaf"
  license "MIT"
  head "https:github.comgruntwork-iocloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582b3fb3d3ffeb83e98a90d80b8c64ba08e015916c22c1d9b6bc64e5dd0d37ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "582b3fb3d3ffeb83e98a90d80b8c64ba08e015916c22c1d9b6bc64e5dd0d37ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "582b3fb3d3ffeb83e98a90d80b8c64ba08e015916c22c1d9b6bc64e5dd0d37ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2527b365eb8acc6d50dc858f2c7818c0d6183902c960288cc091960a8dbc986"
    sha256 cellar: :any_skip_relocation, ventura:       "e2527b365eb8acc6d50dc858f2c7818c0d6183902c960288cc091960a8dbc986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c496cef1fcc8d5a88663fb03e1956576a51c934ded654295b3a6abfa2dd72178"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}cloud-nuke aws --list-resource-types")
  end
end