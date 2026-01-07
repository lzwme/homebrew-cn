class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.0.0.tar.gz"
  sha256 "ec6964b1e52d08715af57f4d817b167a69cc7c7109f29d0f0b797848df2a88a5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "878281239d7e14deabbc77793efc8847fbf6f5a9e0327ed6a0d1a1f14606c093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b41cf906086f11ed49b4aab2e718a8e89e2f78014f9cd2ed45d27c2ded71fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cb1eefcd04453bf1db83d0fe0fa063dcb1a42b3dfe2357394c60b2e1688e434"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cec0ba3d10416ec05734831bf63f80636937433bff381497d633db34f65bcdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aea729dc041d8566bfc97141e357530870491f74d82f4b63ee1b54580715397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd5ff75966b51994abcf2729240117e044eeb0416babe51445626aa6cc49a4a5"
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