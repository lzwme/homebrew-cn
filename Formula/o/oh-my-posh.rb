class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.7.0.tar.gz"
  sha256 "0d7762f70c6abb1c47973ceb7caf53797e1ab0d6f53541261a30c9759e49dd54"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d549464bb6862264a2d8a31730083ca9a43c2f057494e9b7c4383f7f3e219374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77c2b599459910c6ef919358e1e2d87859f69c5106bd09786b2302527ac18ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56fb4047384ee993741713ca4c2f7fd96e1d510f3eaaa154a5bc9ca1c711c21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1211d3d96708928b888e1bdb85aa52c314683b9c9baaa35ac32eb1ff3f00a6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7606b5641796d78b1212f707fb76e62846e07c4fb4ea42357ec9b4642b403cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73794a0c11acf17c0b1304ba82d8ea8d1d839702bd8aba6979a3c010c5c383d9"
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