class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.1.0.tar.gz"
  sha256 "5a06faadf389ab65c6e975600d2c2aada25ccc10e00ac941b490442bb51839f1"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d082eeabe561411318f524d84aeb991b4b350f64c851717a5932d4bcc8de38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f319138fb70f2034579924fc7e05a8906fb462c75c3d8924569965c8958b0b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "364b159e46c095e0d0795364cc6903362f8e7cac13a04932d5b54d908e77c325"
    sha256 cellar: :any_skip_relocation, sonoma:        "920efbbb341366c6f59ce548e6035eb9540bae857c7e888d2cc59a7a6b99f977"
    sha256 cellar: :any_skip_relocation, ventura:       "6352783690fe4856e8c6dc42583b626c169da171e4fd8186dd2f299593f55e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdfa1e5a74a4b5795e426e32cbbcf9a7b595701a104d4cbab1fa034f79dde422"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Your context is not set", shell_output("#{bin}okteto context list 2>&1", 1)
  end
end