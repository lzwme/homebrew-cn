class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.49.1.tar.gz"
  sha256 "d251ef5a1213c0deaad2df569ff68b49e7fbc4c9d186cf79939bbe855cf54ae9"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd81f3983765a2b6aaa222c9235d6ac119446ad19bf3fe0ab823cb2e246225a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd81f3983765a2b6aaa222c9235d6ac119446ad19bf3fe0ab823cb2e246225a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd81f3983765a2b6aaa222c9235d6ac119446ad19bf3fe0ab823cb2e246225a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6228452d6b015b0483bd9fbd97eb8017987043a267c8030b7274fb35b5077cdc"
    sha256 cellar: :any_skip_relocation, ventura:       "6228452d6b015b0483bd9fbd97eb8017987043a267c8030b7274fb35b5077cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17ff11655a79dba10e8986705427c71553bbe5271bd2bef997a8e0dcabfd02f"
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