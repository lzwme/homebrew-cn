class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.33.0.tar.gz"
  sha256 "d16856e476b0c92fdc766ee70f9324bf14677d08e6004bdf77aaae8f1ae0f8f4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a116b4a2e192e1bf9f56573d507f47b9a9f9c233e71272e6812a95d97b699c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19a551c8884970054944e43e81730a6423fbf5796106f22ee2918af05fc9d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a297e480c24272fad22cbabb80d7d71eaeeee9f3f2c166a9f5602e545ba7eea1"
    sha256 cellar: :any_skip_relocation, sonoma:        "47586bde4fe00eb860fc4224e9ac77293c47cf98e8ab2561d138b89edb528ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7f911a1d95103807d32a96cfe822b1ba9235e98515b90758772ae29562bc7ec"
    sha256 cellar: :any,                 x86_64_linux:  "fd072ea57eb2d3f184126bccdbb065b7d383b1b96d771412d282f020fe9b957a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end