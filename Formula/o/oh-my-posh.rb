class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.18.0.tar.gz"
  sha256 "43db77d8c1c78922c4d1d3eacdf341629ecaf8e0277c6115f3eb01d45cecc62d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f4b3c4ce793e6e1a3603dade1c2bf93394f2f6517f6114b596aa02d18b47f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1238421c99f8a78cb05fd54d7f3e7a26d0545cdd72e88ce120e8fe1214b4039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b4b655d329fda4cde42dacbece1cc25f053fe0dc30f034891de2d7e638077e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29aa333a55d0614bd40ad3378fddcb4246c8f60c14a102789f13f98d78eb7864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1060a644efc413a5e20206bbc1bdde64a4206fc4877cd020cf65ecb7b199a8c5"
    sha256 cellar: :any,                 x86_64_linux:  "c3199ce4ae8be760d38b2d2c968b551bb38bd25de201b6e03b658d8b9a43717a"
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