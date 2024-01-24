class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.24.1.tar.gz"
  sha256 "916a1f225f12fd7d3630849699a027de9e713e54ea415c0fe5e178d5ba506ff5"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "496f2025128c83e270de8cebb0c56f1e931da00b50e5162bcd878327c3b42d95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f30edf2ca49d9fbbec1366e7b89be7e80783915ae954e364691ca6d19bb393"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3207fa58f534c21d22cfce1ec8e1c20da7962af52e527f698b2b8305541e9841"
    sha256 cellar: :any_skip_relocation, sonoma:         "12edaa810a783cc27762200bcb789c5cb8dbd85c3ddfab765dc22b33dc8bdb15"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b6546906d6e72c2ac9b9aa100fdad58717e426eaceb0f1a092de1087ed38ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d97233a2e8e7e4ae8a18944352ccb8d6ad01f26bbd817b5ee0c3e0622237de7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb95b5b6c0413725f2c4466478d4b2996f2bb8735597ab3a196dd5d3ce1191b1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end