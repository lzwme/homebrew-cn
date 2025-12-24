class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.5.1.tar.gz"
  sha256 "a0da3bd1cf25249a43438a9ad04a697164dbf56f2a88f2128a09b771a76ae1ca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a693cf5e5cd1f2d51a7df16ff4ed3aa904dc9906e73513c4e8167ebbb5612f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10acc12ed55fff770f1cfad5223a36536134217a158a99988ba4f1f38ca6a637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc805cf9b1cae47cf218f5fee735ef0260d9214cb8f3f425721427b5d74934ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d60242ba067594d428e698097f9214e41c92da729f8fadf74faefd252f6e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82cf7edcfb69619c6a76aacbc9d0f801709d8f6692c431cea4703288bce65efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2694c232894a2d30fb80f62bd900127a70239236435575f6974b77d9fa733b7"
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