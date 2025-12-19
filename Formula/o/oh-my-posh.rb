class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.3.1.tar.gz"
  sha256 "0486007d0f1426bf1c6478a77058c217e5a5bf084a4ca7c2516849c590ed3073"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00aad1b433eb17ef33662ee65bfa10c4bd29abe2fe4ca9cfa8dd7656021199b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb785ed56be1b5652d26fc89057285b74cf0b00ac5f9f099d8f8d0f15d76bad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ed8aefaaaf000d0cd3950c89f2b18c68edc8a8a4ca8467e0ec68a4175166ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3c0b687bd62224c8ec47960abd94eec258c1fc482f5a25c366bd715530513d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74556e6e0214c9569eb1b1f422b8c0d43be2d11eb1263590e18f2af3aa9df690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57bf7517a39b9e8ab6a8e25a46e62d44208f1e93cb5900d5a2707289b5ef2dec"
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