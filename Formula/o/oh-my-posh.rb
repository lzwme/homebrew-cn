class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.3.0.tar.gz"
  sha256 "b6183e15b2fe27e6571ca9f4a0fb92861d70a66fa4401836c1298d9b96733e3a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052d64a4e55260f1d1e7c6e1ccf3308101f4e3a458c19958206c5203b499653b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a5bd3f911aa75fda3b811c3987d8dc6ffa2a0298554a30b672ab83f0e51b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e618d9258a25e19eefaab1a7a7f1520d1e594c96dd29a0f85ed421ac9c494ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d562337ed32ed639c662f6d7bfa88832548eccec3f105de50126471772829987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d90620b38480e1bb2ce2659ec6c7a7c4e3d5d76470962acfe464ca6883bbd248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94860d0e72dab8285ad097c22284f72c6e583e119cbc57f5d3c0203f87ae2d15"
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