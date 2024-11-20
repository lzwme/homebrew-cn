class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.48.0.tar.gz"
  sha256 "f2b00930b14332b24e2bec46a948f986759e97d193b9abc0e208560a71efa1ae"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a069d5efe01f077ca6f0e2d836c78328afbf91b428027635dbb0e90ef4bb66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a069d5efe01f077ca6f0e2d836c78328afbf91b428027635dbb0e90ef4bb66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7a069d5efe01f077ca6f0e2d836c78328afbf91b428027635dbb0e90ef4bb66"
    sha256 cellar: :any_skip_relocation, sonoma:        "3400097dc69338580f18f78e8a8838d886a62f158cf195ccb6943bb2fec90bbb"
    sha256 cellar: :any_skip_relocation, ventura:       "3400097dc69338580f18f78e8a8838d886a62f158cf195ccb6943bb2fec90bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1a0a94fb0e37a43f3e50859b978cd842fa39f991b466e599597224d7945c1f"
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