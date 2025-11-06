class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.5.1.tar.gz"
  sha256 "a9e84914f6377e03cc8dc96706c9f2f40c6ebc93f710c2d9ce8a078f3583a978"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6234ba247d94e2c6a8748df9cc61a33d6c6da9df9a97aaad89a3fd94fe9180c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb24a76a567bac056aa4c54edcdb292f8fcad13e06c6bf135a668e9992bbad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89bac929ca2434231bf4460010d9ac23c69b935b277dbf18f9cbd8308d4c944"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fbfa8fece2929e957717a69f85bc17d2c14baeba8334cf1f9c5562fcafb862d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9fde0bb8bdb598c2babe51d5511fd6ac3cf7ed487aa80eea00b64edb9259dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90291c8b62edee3607b42ae03df0a4c4721b4e6197f50ca6ec0fce1d4d192c25"
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