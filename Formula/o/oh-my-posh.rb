class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.4.0.tar.gz"
  sha256 "3f30a5c0e1ec53d994dba573b1aea6566cca8b6341fc1eb0cb5349d7a7dfb491"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af92361d603e3250028382f7995d94e8ca554c348ffdce545d8a6bc8d873e73d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dffb4aa595910a3c802f8bddb4eaac74b1e17051dea55d481cc17ce1da1a3e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ebc22bedd38998771c8bf644ec8f787145d0f4988f9ff73a55c74eccd0578a"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b8c9fa7942c7ae57e2264b8955e9f9aa25c23dee8d1895be771a6c362b0168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409c53175bd86bdb85603d402b270ea1ffcf590639be146adca8b193567d0dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f111e4acbb18f92cb0cc9843233876afb54832af15fd1466934de3b5724e86f2"
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