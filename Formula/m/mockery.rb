class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.46.1.tar.gz"
  sha256 "f0f7627b535ffa7c8e40b4b7a30afa51919658c98b2175edbcae30da6c1dcff6"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d8605f58f78859ab53378a5b4c4c2e6e2fec297a9dc43ecbd1566f28cf102a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d8605f58f78859ab53378a5b4c4c2e6e2fec297a9dc43ecbd1566f28cf102a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53d8605f58f78859ab53378a5b4c4c2e6e2fec297a9dc43ecbd1566f28cf102a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e71b3af672b9a6eb83f9743851bbba25c25f76f2d29fa2d5f751f038a2dea35"
    sha256 cellar: :any_skip_relocation, ventura:       "1e71b3af672b9a6eb83f9743851bbba25c25f76f2d29fa2d5f751f038a2dea35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9438bfe8f6fe5be8f93efe31394c5e58e6cb0546b0965d32c2679314d1d49bb0"
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