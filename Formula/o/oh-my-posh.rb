class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.3.tar.gz"
  sha256 "135ec88a39ecaea7fead0c1ccaeb520248e4451021f257e469e0fccd08882c97"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c179b33a4dd7caadb86fe98934b1d2889c2ed6be9673a571abe1d4748fe8d8ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f985cdec9c288cecca7dd3d44371435c1b6afe4d4e6b66bd1ebc9bbe3387a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c038ecda93532e5c7b2a028dd563ee703cc65ab496eed7b766142803e9a2e483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1ad0997a5a2abbb4f2a37dfc2d62cd4a837661dec5d722eb16b642fe13bbc9"
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