class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.4.0.tar.gz"
  sha256 "243e286d24ebc7c68500d16c43f6c920876e548b229695450d5048a5d456b306"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb82226a028b3e0936a15f93f13e72ff88d62c3764ebecabce85646adbec7b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd305c003e9636ecb61bba471819310e525cfd8ca7a95d31c9b8813379b1e1d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203c2e2ca6e0017f2e9d5eada67029abba8bedf1594477d9e823069d48cc15ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec20c5da3b26a05feea3e1d44585dd361732d5fd10501122465c300c03e9d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb297a02d13f8bfcd2018e0a506b6b543d9c9bd53febf7e26f17e5b6d4c58f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170ba5d4d4fcec6acad1dc42571444b256e8a0b3fefe7d2d9ec6b89132bada04"
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