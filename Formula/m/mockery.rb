class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.43.1.tar.gz"
  sha256 "441db8b6e0b3e7b8cc94224a3b77246f86b4ef57ba0ac7379c0002862ff24ea3"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2da1a16e3d0b9b78767cc979bae552570ac219819e844c4f5c9f0bdae8fa4f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac8d4c042ff67c3905b91b6ad426c8066288f77c8d3d6ec332ecb9b21f736a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bed75b166e7f61219c8016b4a207688413d27b2cbe605ccaafc3f9ed3e2ee681"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb74a5aab4fa59a106f457750889c4e785846e0fdc73ebbbcab414e71c7ce2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "c5cad05c8b187a4d42c90d304651b0dc555518044f419e19769a7c0a025380ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c5177655a7b36bde7ac40e2af383f7c401a666d0c19f6e8dd55fb7114154e7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bf82a79bbdd91923cf700c40b7c96edf0e63a3f8d034d56b2dd4a8301898eb"
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