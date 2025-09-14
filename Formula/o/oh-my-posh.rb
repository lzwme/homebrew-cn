class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.4.tar.gz"
  sha256 "273f9f431ff93a3849e269ecd6821dd435b7b0992348fc276588179e66df663b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc6b0127edd21c8ef229f2a9424dca37499b15802ba019ab2e03554e49abaa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505bcdc6909aee75112e29c37b65bfe75e234e7d13184851f394f8cba55f45a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e379ac14bf8b3872c7ec453d23f4f2d4a80254f4f34e1b6c3f5db5db503ed416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39dfab5d3884002129d6d9c7e869f8f8b1373a50ee506452c1ab93c25874257"
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