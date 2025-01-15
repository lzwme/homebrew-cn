class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.51.0.tar.gz"
  sha256 "496842899a76c22e5cd3f050a0c4a093fe4897047c008ecf62765107e1ec52b9"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50cf3db7199694d2e7682e482ebf885f2808f465df07809e46e750b33fa8056f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cf3db7199694d2e7682e482ebf885f2808f465df07809e46e750b33fa8056f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50cf3db7199694d2e7682e482ebf885f2808f465df07809e46e750b33fa8056f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd50a6cf8898bae2c5f5abee67a22ebca52bcd36952a2597d6ac1d1fcb1511b"
    sha256 cellar: :any_skip_relocation, ventura:       "8dd50a6cf8898bae2c5f5abee67a22ebca52bcd36952a2597d6ac1d1fcb1511b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efff519bffbdd3ca9d4cc4f1b8d135490533fe85865f7831b581fad4edb84f2f"
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