class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.19.1.tar.gz"
  sha256 "bde02db5c9258400f68f01029bce8fabb543bafa8cb38297de018f7f668826c6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88a0ea1db8a61fac6ce58bbb65d70741febf5778ca79ebce6f5ea93f0e167af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b568e62f7f8d06b548d07d3530cf366fc1177c7e5aa2727d1ecb4b380d8c3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6394bbcc35bbfdf6f0c4bc68ac798489da5ede3217637060e40ae3630784f010"
    sha256 cellar: :any_skip_relocation, sonoma:        "80270a03ff7af21ca8290660ca963f71c0da6b738a023a0ad4d72a6d8c41495b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a765d067fc72eda7bf135a26b706c253c93f37272e0128a015900a1493c8e181"
    sha256 cellar: :any,                 x86_64_linux:  "d26df9b30fd2b1af35d4db8328433f11b04504c41dcf28caaba3f1073abee2f3"
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