class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.2.0.tar.gz"
  sha256 "473537672ddff310e559b00cf84f4403f77bfd6ac538190cbc842b0ee6f4da48"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c611f61fb136cad4047c556cf4357b08d18d1d7fa47a99b897a544f7a57d805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b662c7571e8eca0f289de70cab6feecb849c2dfe72300375732ccb1fe88b656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49533238635c09ed1202b8ba7104ddc682922fef4eb5636ae15776c117c6360d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7604c3af58695b4496b93da858c7a0ed71a7e34d849ba93353094bbf665ed202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c60598a0c3b0c71ffb95d6f318ab6f4776d477128b67c6db2f760d39793f68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96deab6348c59ca4c5739eb557db00b337ce531d7ba417a8bf0ca0f0e7c8e1ec"
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