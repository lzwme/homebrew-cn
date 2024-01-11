class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.39.2.tar.gz"
  sha256 "38ef601240a639a22e4daa727922ab545ae5b6f0d3630bb4c4f06a0ba8c59745"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c52fbf49a4c20d0335bce85ea12db166b821d8e8484c021ee8bfb7065a155f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f63d529b828d7975b3231396299ef9e081d11964422766d7f8bdd912c2aebb04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8949c7f842f602eeb6a5ccc215f318e86df7d64ae7d08d967faec587b73d67b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "98fb7c69a358413ecd862a3db47b1124ecbc2e1daa0995e1e2d82f497e54f0dd"
    sha256 cellar: :any_skip_relocation, ventura:        "5ddee157aacdfdfe6c212244276cdd9ce9477253b97b0012787b6c6d24df44ad"
    sha256 cellar: :any_skip_relocation, monterey:       "6a44e30752be199bb868a0a351408c215e9bfc775bf03521756cc7a315519772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548e8ba1ff8dad8bdc1dd19611098dafb182820393442983714be87eb172012e"
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