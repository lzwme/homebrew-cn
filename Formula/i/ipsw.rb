class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.576.tar.gz"
  sha256 "edd03568ebc954705064f161e40e440b6305325fee0ad6f79c7fa0bf0f3e016c"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7e5eaa323b1bf911bfa242ad1a65df17c5debe39eb876dc32bfc0d5acdaeb65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c4a02154e681619365fd9ed4b968f1624661e62efce2c561c5c0738b90f1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57304b9fae7c9df59cf488a94ce6ae42f8d2ae86a479afcebead4aac6b4b0260"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb40fe242c773a4b42a98d5283a9a9d1f216ff7f7535d78e412c340d3ec9b9e"
    sha256 cellar: :any_skip_relocation, ventura:       "5ef7ce6f28c735e72f275cd591adaab03946f27b5a66e86eaf628730c219dd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dac0f80e55a6e0790701f3a6fc63ed300f13d6aa8262766fabc449b259c1684"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end