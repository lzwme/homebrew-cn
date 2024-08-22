class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.45.0.tar.gz"
  sha256 "71e3ae413dc636c4bee2ae21e73ffd20e209e0124ea4168a39e3133c06601b85"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4745d71be499b8884e6504fa0feb5cda5902db6e69501f55cada8279c2f12641"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4745d71be499b8884e6504fa0feb5cda5902db6e69501f55cada8279c2f12641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4745d71be499b8884e6504fa0feb5cda5902db6e69501f55cada8279c2f12641"
    sha256 cellar: :any_skip_relocation, sonoma:         "2891f1cb5321d25b3a53621cbb60445010c5056ff28332fa7e426d71daf98066"
    sha256 cellar: :any_skip_relocation, ventura:        "2891f1cb5321d25b3a53621cbb60445010c5056ff28332fa7e426d71daf98066"
    sha256 cellar: :any_skip_relocation, monterey:       "2891f1cb5321d25b3a53621cbb60445010c5056ff28332fa7e426d71daf98066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cf5fd06fd2bcb91efd2e7546a774bbfafd08c780d406a7ae8e3b517e77c60d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end