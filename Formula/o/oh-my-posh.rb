class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.31.0.tar.gz"
  sha256 "4f20b2516cc38757656f456225408344d881333b9fb0f68bf4455d30b06fe91a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce2d0428514422d1f7f1b4ce9547a594636a712c61400bcb17089e327d3f525e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967d9c2a2f1cb8676c82e4dcd4295bd5423518caee92058660076856445954ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85725eb93824382fe3b729fd7e8aefde75dcbc7812ee685a2a185c25c897e35e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b46d988937bf06bc6449b9029bd17487586097e5e0b9ad65c1dc4c29d668ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d9bffb4b8483fcb6abf2dc53b802aac0ba6f525936bcfc58c97fd060f41add"
    sha256 cellar: :any,                 x86_64_linux:  "bae2612c6fc92130f153664a349e2b006b6af52a15c0557103becf9fb8160ab3"
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