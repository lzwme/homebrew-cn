class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.5.0.tar.gz"
  sha256 "f8984d52500d7fe0b83574592ec4eae8e84e192fd10650fb3cfd6a37b657bdb6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5454875399c1c7d3a6bbee1fdc112cc9d6efd44e1750d0926b2d322654911cd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "021dd9961a7d5dd7284629e9a38f5227712b71511079dc2c378b75ab9b6a09b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ee618ab050454e4339f6a022d201c78a5c4f81c1d6116aca7b0184504ec88f"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e745cbc9c31c4309ffee52d3c44f8bccc739f4a25d3fcff54921faf4301d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b5f9cb3373bbc0b5baea40a663c1d76d45ef207eb5d32879d4e90ab81aa67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f50e6ba69923556d2cd0a04baff398c46d1ad2ddda2fbb3d4919aa7aafd1a21"
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